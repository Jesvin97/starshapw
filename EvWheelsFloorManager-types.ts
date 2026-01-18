// Core Types for EV Wheels Floor Manager React Native App
// These types mirror the web implementation for consistency

export type UserRole =
  | 'admin'
  | 'front_desk_manager'
  | 'technician'
  | 'manager';

export type ServiceTicketStatus =
  | 'reported'
  | 'triaged'
  | 'assigned'
  | 'in_progress'
  | 'completed'
  | 'delivered'
  | 'closed'
  | 'cancelled'
  | 'on_hold'
  | 'waiting_approval';

export type Priority = 1 | 2 | 3; // 1=High, 2=Medium, 3=Low

export interface User {
  id: string;
  email: string;
  firstName?: string;
  lastName?: string;
  role: UserRole;
  imageUrl?: string;
  createdAt: string;
  updatedAt: string;
}

export interface Customer {
  id: string;
  name: string;
  contact: string;
  email?: string;
  address?: string;
  createdAt: string;
  updatedAt: string;
}

export interface ServiceTicket {
  id: string;
  ticketNumber: string;
  customerId: string;
  customer?: Customer;

  // Problem description
  symptom: string;
  description?: string;
  customerComplaint?: string;

  // Vehicle information
  vehicleMake?: string;
  vehicleModel?: string;
  vehicleRegNo?: string;
  vehicleYear?: number;

  // Status and assignment
  status: ServiceTicketStatus;
  priority?: Priority;
  assignedTo?: string; // User ID of assigned technician
  assignedBy?: string; // User ID of who assigned

  // Dates
  createdAt: string;
  updatedAt: string;
  dueDate?: string;
  closedAt?: string;
  triageAt?: string;

  // Metadata
  createdBy: string;
  updatedBy?: string;
  triagedBy?: string;
  triageNotes?: string;

  // Linked cases
  batteryCaseId?: string;
  vehicleCaseId?: string;

  // Location context
  location?: {
    id: string;
    name: string;
  };
}

export interface TicketAttachment {
  id: string;
  ticketId: string;
  fileName: string;
  originalName: string;
  storagePath: string;
  fileSize: number;
  mimeType: string;
  attachmentType: 'photo' | 'audio' | 'document';
  thumbnailPath?: string;
  duration?: number; // for audio files
  uploadedBy: string;
  uploadedAt: string;
  processed: boolean;
}

export interface VehicleCase {
  id: string;
  serviceTicketId: string;
  vehicleMake: string;
  vehicleModel: string;
  vehicleRegNo: string;
  vehicleYear?: number;
  vinNumber?: string;
  customerId: string;
  receivedDate: string;
  deliveredDate?: string;
  status:
    | 'received'
    | 'diagnosed'
    | 'in_progress'
    | 'completed'
    | 'delivered'
    | 'cancelled'
    | 'on_hold';
  initialDiagnosis?: string;
  symptomsObserved?: string;
  diagnosticNotes?: string;
  repairNotes?: string;
  technicianNotes?: string;
  partsRequired?: string[];
  partsCost?: number;
  laborHours?: number;
  laborCost?: number;
  estimatedCost?: number;
  finalCost?: number;
  assignedTechnician?: string;
  createdAt: string;
  updatedAt: string;
  createdBy: string;
  updatedBy: string;
}

// Dashboard KPIs
export interface DashboardKPIs {
  openTickets: number;
  inProgressBatteries: number;
  dueToday: number;
  overdue: number;
  weeklyCompleted: number;
  avgTatDays: number;
  unassigned: number;
  slaRisk: number;
}

// Team workload
export interface TechnicianWorkload {
  assignee: string | null;
  count: number;
  capacity: number; // Usually 8
  name?: string;
  email?: string;
}

// Notification types
export interface Notification {
  id: string;
  type:
    | 'assignment'
    | 'status_change'
    | 'overdue'
    | 'new_ticket'
    | 'priority_change';
  title: string;
  message: string;
  ticketId?: string;
  ticketNumber?: string;
  read: boolean;
  createdAt: string;
  actionUrl?: string;
}

// API Response types
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  count: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

// Form types
export interface CreateTicketForm {
  customerId: string;
  symptom: string;
  description?: string;
  vehicleMake?: string;
  vehicleModel?: string;
  vehicleRegNo?: string;
  vehicleYear?: number;
  priority?: Priority;
}

export interface UpdateTicketForm {
  symptom?: string;
  description?: string;
  priority?: Priority;
  status?: ServiceTicketStatus;
  assignedTo?: string;
  dueDate?: string;
  triageNotes?: string;
}

export interface AssignTechnicianForm {
  ticketIds: string[];
  technicianId: string;
  priority?: Priority;
  dueDate?: string;
  notes?: string;
}

// Filter and search types
export interface TicketFilters {
  status?: ServiceTicketStatus | 'all';
  priority?: Priority | 'all';
  assignedTo?: string | 'all' | 'unassigned';
  dueDate?: 'overdue' | 'today' | 'tomorrow' | 'this_week';
  customer?: string;
  vehicleReg?: string;
  search?: string;
}

export interface SortOptions {
  field: 'createdAt' | 'updatedAt' | 'dueDate' | 'priority' | 'status';
  direction: 'asc' | 'desc';
}

// Authentication context
export interface AuthContextType {
  user: User | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  refreshUser: () => Promise<void>;
}

// Navigation types
export type RootStackParamList = {
  Auth: undefined;
  Main: undefined;
};

export type AuthStackParamList = {
  Login: undefined;
  RoleAssignment: { userId: string };
};

export type MainTabParamList = {
  Dashboard: undefined;
  JobCards: undefined;
  Notifications: undefined;
  Team: undefined;
  Profile: undefined;
};

export type DashboardStackParamList = {
  DashboardHome: undefined;
  JobCardDetails: { ticketId: string };
  AssignTechnician: { ticketId: string };
};

export type JobCardsStackParamList = {
  JobCardsList: undefined;
  JobCardDetails: { ticketId: string };
  CreateJobCard: undefined;
  EditJobCard: { ticketId: string };
  AssignTechnician: { ticketId: string };
};

export type NotificationsStackParamList = {
  NotificationsList: undefined;
  NotificationDetails: { notificationId: string };
};

export type TeamStackParamList = {
  TeamWorkload: undefined;
  TechnicianDetails: { technicianId: string };
};

export type ProfileStackParamList = {
  ProfileHome: undefined;
  Settings: undefined;
};

// Store types (Zustand)
export interface AuthStore {
  user: User | null;
  loading: boolean;
  setUser: (user: User | null) => void;
  setLoading: (loading: boolean) => void;
  signOut: () => void;
}

export interface JobCardStore {
  tickets: ServiceTicket[];
  loading: boolean;
  filters: TicketFilters;
  setTickets: (tickets: ServiceTicket[]) => void;
  addTicket: (ticket: ServiceTicket) => void;
  updateTicket: (ticketId: string, updates: Partial<ServiceTicket>) => void;
  removeTicket: (ticketId: string) => void;
  setLoading: (loading: boolean) => void;
  setFilters: (filters: TicketFilters) => void;
}

export interface NotificationStore {
  notifications: Notification[];
  unreadCount: number;
  setNotifications: (notifications: Notification[]) => void;
  addNotification: (notification: Notification) => void;
  markAsRead: (notificationId: string) => void;
  markAllAsRead: () => void;
  clearNotifications: () => void;
}

// Constants
export const TICKET_STATUS_LABELS: Record<ServiceTicketStatus, string> = {
  reported: 'Reported',
  triaged: 'Triaged',
  assigned: 'Assigned',
  in_progress: 'In Progress',
  completed: 'Completed',
  delivered: 'Delivered',
  closed: 'Closed',
  cancelled: 'Cancelled',
  on_hold: 'On Hold',
  waiting_approval: 'Waiting Approval'
};

export const PRIORITY_LABELS: Record<Priority, string> = {
  1: 'High Priority',
  2: 'Medium Priority',
  3: 'Low Priority'
};

export const PRIORITY_COLORS: Record<Priority, string> = {
  1: '#EF4444', // red-500
  2: '#F59E0B', // amber-500
  3: '#6B7280' // gray-500
};

export const STATUS_COLORS: Record<ServiceTicketStatus, string> = {
  reported: '#EF4444',
  triaged: '#F59E0B',
  assigned: '#3B82F6',
  in_progress: '#8B5CF6',
  completed: '#10B981',
  delivered: '#059669',
  closed: '#6B7280',
  cancelled: '#EF4444',
  on_hold: '#F59E0B',
  waiting_approval: '#F59E0B'
};
