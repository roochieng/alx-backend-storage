#!/usr/bin/env python3
"""
Module 10-update_topics
"""


def update_topics(mongo_collection, name, topics):
    """
    Changes all topics of a school document based on the name
    """
    result = mongo_collection.update_many({"name": name},
                                          {"$set": {"topics": topics}})
    return result
