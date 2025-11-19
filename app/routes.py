from flask import Blueprint, jsonify, request, Response
from .models import db, Room, Guest, Booking

from prometheus_client import Counter, generate_latest

main = Blueprint("main", __name__)

# Prometheus Counter
REQUEST_COUNT = Counter('hotel_app_requests_total', 'Total number of requests')


# 🔥 Count every request in the entire Flask app
@main.before_app_request
def before_request():
    REQUEST_COUNT.inc()


# Prometheus Metrics Endpoint
@main.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype='text/plain')


# Health Check
@main.route("/")
def home():
    return jsonify({"message": "Hotel Management API Running"})


# CRUD for Rooms
@main.route("/rooms", methods=["GET", "POST"])
def handle_rooms():
    if request.method == "GET":
        rooms = Room.query.all()
        return jsonify([{
            "id": r.id,
            "room_number": r.room_number,
            "type": r.type,
            "price": r.price,
            "status": r.status
        } for r in rooms])

    if request.method == "POST":
        data = request.json
        new_room = Room(
            room_number=data["room_number"],
            type=data["type"],
            price=data["price"]
        )
        db.session.add(new_room)
        db.session.commit()
        return jsonify({"message": "Room added successfully"}), 201
