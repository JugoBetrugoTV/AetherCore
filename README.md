# AetherCore

> A powerful, modular, and extensible framework for building modern applications with advanced theming, data tracking, and plugin architecture.

![Status](https://img.shields.io/badge/status-active-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Version](https://img.shields.io/badge/version-1.0.0-informational)

## 📋 Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Architecture Overview](#architecture-overview)
- [Theme System](#theme-system)
- [Module System](#module-system)
- [Creating Custom Modules](#creating-custom-modules)
- [Data Tracking](#data-tracking)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Roadmap](#roadmap)
- [Support](#support)
- [License](#license)
- [Author](#author)

## ✨ Features

### Core Features
- **Modular Architecture**: Build applications with a plugin-based system for maximum flexibility
- **Advanced Theming System**: Create and manage multiple themes with dynamic switching
- **Data Tracking & Analytics**: Built-in tracking system for user interactions and application events
- **Configuration Management**: Centralized configuration system with environment support
- **Event System**: Publish-subscribe event handling for decoupled components
- **Middleware Support**: Chain middleware for request processing and data transformation
- **Hot Module Reloading**: Development mode with hot reload capabilities
- **Type Safety**: Full TypeScript support with comprehensive type definitions

### Advanced Capabilities
- Real-time event streaming
- Custom module development framework
- Extensible logging system
- Performance monitoring and metrics
- State management utilities
- Error handling and recovery
- Security features and best practices

## 📦 Installation

### Requirements
- Node.js 16.0.0 or higher
- npm 8.0.0 or higher (or yarn 1.22.0+)

### npm Installation

```bash
npm install aethercore
```

### yarn Installation

```bash
yarn add aethercore
```

### pnpm Installation

```bash
pnpm add aethercore
```

### From Source

```bash
git clone https://github.com/JugoBetrugoTV/AetherCore.git
cd AetherCore
npm install
npm run build
```

## 🚀 Quick Start

### Basic Setup

```javascript
import { AetherCore } from 'aethercore';

// Initialize AetherCore with default configuration
const aether = new AetherCore({
  appName: 'MyApp',
  environment: 'development',
  logging: {
    level: 'info',
    enableConsole: true
  }
});

// Start the application
await aether.initialize();
```

### Loading a Theme

```javascript
// Load a built-in theme
await aether.themeManager.loadTheme('dark');

// Or apply custom theme
await aether.themeManager.applyTheme({
  name: 'custom-theme',
  colors: {
    primary: '#007bff',
    secondary: '#6c757d',
    background: '#ffffff'
  }
});
```

### Registering a Module

```javascript
// Register a module
aether.moduleManager.register({
  name: 'analytics',
  version: '1.0.0',
  enabled: true,
  handlers: {
    onInit: async () => {
      console.log('Analytics module initialized');
    },
    onTrackEvent: (event) => {
      console.log('Event tracked:', event);
    }
  }
});

// Enable the module
aether.moduleManager.enable('analytics');
```

### Using Event System

```javascript
// Subscribe to events
aether.on('user:login', (user) => {
  console.log(`User ${user.id} logged in`);
});

// Emit events
aether.emit('user:login', {
  id: 123,
  username: 'john_doe',
  timestamp: new Date()
});
```

## 🏗️ Architecture Overview

### System Architecture

```
┌─────────────────────────────────────────┐
│         AetherCore Application          │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │    Application Layer            │   │
│  │  (Event Handlers, Routes, UI)   │   │
│  └──────────────┬──────────────────┘   │
│                 │                      │
│  ┌──────────────▼──────────────────┐   │
│  │    Module System                │   │
│  │  (Plugins, Extensions)          │   │
│  └──────────────┬──────────────────┘   │
│                 │                      │
│  ┌──────────────▼──────────────────┐   │
│  │    Core Services                │   │
│  │  (Event Bus, Config, Logger)    │   │
│  └──────────────┬──────────────────┘   │
│                 │                      │
│  ┌──────────────┴──────────────────┐   │
│  │  Feature Modules                │   │
│  ├─────────────────────────────────┤   │
│  │ ├─ Theme Manager                │   │
│  │ ├─ Data Tracking                │   │
│  │ ├─ State Management             │   │
│  │ ├─ Logging System               │   │
│  │ └─ Middleware Chain             │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

### Core Components

- **EventBus**: Central event management system
- **ModuleManager**: Handles module registration and lifecycle
- **ThemeManager**: Manages application themes
- **ConfigManager**: Centralized configuration management
- **DataTracker**: Tracks and records application events
- **Logger**: Multi-level logging system
- **MiddlewareChain**: Request/response processing pipeline

## 🎨 Theme System

### Built-in Themes

AetherCore comes with several pre-configured themes:

- **Light**: Clean, bright theme suitable for daytime use
- **Dark**: Low-light theme to reduce eye strain
- **Modern**: Contemporary design with gradients and shadows
- **Classic**: Traditional professional appearance

### Theme Structure

```javascript
{
  name: 'my-theme',
  version: '1.0.0',
  colors: {
    primary: '#007bff',
    secondary: '#6c757d',
    success: '#28a745',
    danger: '#dc3545',
    warning: '#ffc107',
    info: '#17a2b8',
    background: '#ffffff',
    surface: '#f8f9fa',
    text: '#212529',
    textSecondary: '#6c757d'
  },
  fonts: {
    primary: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
    mono: 'Courier New, monospace'
  },
  spacing: {
    xs: '4px',
    sm: '8px',
    md: '16px',
    lg: '24px',
    xl: '32px'
  }
}
```

### Creating a Custom Theme

```javascript
const customTheme = {
  name: 'brand-theme',
  colors: {
    primary: '#FF6B35',
    secondary: '#004E89',
    background: '#F7F9FC'
  }
};

await aether.themeManager.createTheme(customTheme);
await aether.themeManager.loadTheme('brand-theme');
```

### Switching Themes Dynamically

```javascript
// Get available themes
const themes = aether.themeManager.getAvailableThemes();

// Switch to a theme
await aether.themeManager.switchTheme('dark');

// Listen to theme changes
aether.themeManager.on('theme:changed', (theme) => {
  console.log(`Switched to ${theme.name}`);
});
```

## 🧩 Module System

### Module Lifecycle

```
Registration → Validation → Initialization → Active → Disabled → Unloaded
```

### Module Structure

```javascript
{
  // Required
  name: 'module-name',           // Unique module identifier
  version: '1.0.0',              // Semantic version
  
  // Optional
  description: 'Module description',
  author: 'Author Name',
  enabled: true,
  dependencies: ['other-module'],
  config: { /* module config */ },
  
  // Lifecycle Hooks
  handlers: {
    onInit: async (aether) => {},
    onEnable: async (aether) => {},
    onDisable: async (aether) => {},
    onUnload: async (aether) => {}
  }
}
```

### Built-in Modules

#### Analytics Module
Tracks user interactions and application events.

```javascript
aether.moduleManager.register({
  name: 'analytics',
  version: '1.0.0',
  handlers: {
    onInit: async () => {
      console.log('Analytics initialized');
    }
  }
});
```

#### Performance Module
Monitors application performance metrics.

```javascript
aether.moduleManager.register({
  name: 'performance',
  version: '1.0.0',
  handlers: {
    onInit: async () => {
      console.log('Performance monitoring enabled');
    }
  }
});
```

#### Logger Module
Provides comprehensive logging capabilities.

```javascript
aether.logger.info('Information message');
aether.logger.warn('Warning message');
aether.logger.error('Error message');
aether.logger.debug('Debug message');
```

### Module Management API

```javascript
// Register a module
aether.moduleManager.register(moduleConfig);

// Enable a module
aether.moduleManager.enable('module-name');

// Disable a module
aether.moduleManager.disable('module-name');

// Check if module is enabled
const isEnabled = aether.moduleManager.isEnabled('module-name');

// Get module information
const moduleInfo = aether.moduleManager.getModule('module-name');

// List all modules
const allModules = aether.moduleManager.listModules();

// Unload a module
await aether.moduleManager.unload('module-name');
```

## 🔧 Creating Custom Modules

### Step 1: Define Module Structure

```javascript
// modules/myModule.js
export const myModule = {
  name: 'my-module',
  version: '1.0.0',
  description: 'Custom module for AetherCore',
  author: 'Your Name',
  enabled: true,
  
  // Module configuration schema
  configSchema: {
    apiUrl: { type: 'string', required: true },
    timeout: { type: 'number', default: 5000 }
  },
  
  // Module state
  state: {
    isInitialized: false,
    data: null
  }
};
```

### Step 2: Implement Lifecycle Handlers

```javascript
myModule.handlers = {
  onInit: async (aether) => {
    console.log('Module initializing...');
    // Perform initialization tasks
    aether.logger.info('myModule initialized');
  },
  
  onEnable: async (aether) => {
    console.log('Module enabled');
    // Subscribe to events
    aether.on('app:ready', () => {
      console.log('App is ready');
    });
  },
  
  onDisable: async (aether) => {
    console.log('Module disabled');
    // Cleanup subscriptions
  },
  
  onUnload: async (aether) => {
    console.log('Module unloading...');
    // Final cleanup
  }
};
```

### Step 3: Add Custom Handlers

```javascript
myModule.handlers.onUserAction = (action) => {
  console.log(`User action: ${action.type}`);
};

myModule.handlers.onDataUpdate = (data) => {
  console.log(`Data updated:`, data);
};
```

### Step 4: Register and Use

```javascript
import { myModule } from './modules/myModule';

// Register the module
aether.moduleManager.register(myModule);

// Enable the module
aether.moduleManager.enable('my-module');

// Emit events to your module
aether.emit('app:userAction', { type: 'click', target: 'button' });
```

### Complete Example: Analytics Module

```javascript
export const analyticsModule = {
  name: 'analytics',
  version: '1.0.0',
  description: 'Advanced analytics tracking',
  author: 'Your Team',
  
  configSchema: {
    trackingId: { type: 'string', required: true },
    batchSize: { type: 'number', default: 50 },
    flushInterval: { type: 'number', default: 30000 }
  },
  
  state: {
    events: [],
    isTracking: false
  },
  
  handlers: {
    onInit: async (aether) => {
      aether.logger.info('Analytics module initialized');
    },
    
    onEnable: async (aether) => {
      // Start event collection
      this.state.isTracking = true;
      
      // Subscribe to all events
      aether.on('*', (eventName, data) => {
        this.trackEvent(eventName, data);
      });
      
      // Setup batch flushing
      setInterval(() => this.flushEvents(), this.config.flushInterval);
    },
    
    onDisable: async (aether) => {
      this.state.isTracking = false;
      this.flushEvents();
    }
  },
  
  methods: {
    trackEvent(name, data) {
      if (!this.state.isTracking) return;
      
      this.state.events.push({
        name,
        data,
        timestamp: Date.now()
      });
      
      // Flush if batch size reached
      if (this.state.events.length >= this.config.batchSize) {
        this.flushEvents();
      }
    },
    
    flushEvents() {
      if (this.state.events.length === 0) return;
      
      console.log(`Flushing ${this.state.events.length} events`);
      // Send to backend
      this.state.events = [];
    }
  }
};
```

## 📊 Data Tracking

### Event Tracking API

```javascript
// Track a simple event
aether.track('button_clicked', {
  buttonId: 'submit-btn',
  section: 'form'
});

// Track user actions
aether.track('user_action', {
  action: 'login',
  userId: 123,
  timestamp: Date.now()
});

// Track page views
aether.track('page_view', {
  pageName: 'dashboard',
  pageUrl: '/dashboard',
  referrer: '/home'
});

// Track errors
aether.track('error', {
  errorType: 'RuntimeError',
  message: 'Failed to fetch data',
  stack: error.stack
});
```

### Data Collection

```javascript
// Get tracked events
const events = aether.dataTracker.getEvents();

// Get events by type
const clicks = aether.dataTracker.getEventsByType('button_clicked');

// Get events in time range
const recentEvents = aether.dataTracker.getEventsInRange(
  Date.now() - 3600000, // 1 hour ago
  Date.now()
);

// Clear events
aether.dataTracker.clearEvents();
```

### Analytics Query

```javascript
// Get event count
const totalEvents = aether.dataTracker.count();

// Get event statistics
const stats = aether.dataTracker.getStatistics({
  groupBy: 'eventType',
  timeRange: 'last24h'
});

// Export data
const csvData = aether.dataTracker.export('csv');
const jsonData = aether.dataTracker.export('json');
```

### Custom Event Handlers

```javascript
// Subscribe to tracking events
aether.dataTracker.on('event:tracked', (event) => {
  console.log('Event tracked:', event);
});

// Subscribe to specific event types
aether.dataTracker.on('error:tracked', (error) => {
  console.error('Error tracked:', error);
});
```

## ⚙️ Configuration

### Configuration File (aethercore.config.js)

```javascript
export default {
  // Application settings
  app: {
    name: 'MyApplication',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development'
  },
  
  // Logging configuration
  logging: {
    level: 'info', // debug, info, warn, error
    enableConsole: true,
    enableFile: true,
    logDir: './logs',
    maxLogSize: '10mb',
    maxLogFiles: 10
  },
  
  // Theme settings
  theme: {
    default: 'light',
    allowDynamic: true,
    persistSelection: true,
    storageKey: 'aether-theme'
  },
  
  // Module system
  modules: {
    autoLoad: true,
    modulesDir: './modules',
    enableAllByDefault: false
  },
  
  // Data tracking
  tracking: {
    enabled: true,
    persistData: true,
    maxEvents: 1000,
    autoFlush: true,
    flushInterval: 60000 // 1 minute
  },
  
  // Performance
  performance: {
    enableMonitoring: true,
    enableProfiling: false,
    slowThreshold: 1000 // ms
  },
  
  // Security
  security: {
    enableValidation: true,
    enableSanitization: true,
    enableEncryption: false
  }
};
```

### Environment-based Configuration

```javascript
// config/development.js
export const devConfig = {
  logging: { level: 'debug' },
  theme: { default: 'light' }
};

// config/production.js
export const prodConfig = {
  logging: { level: 'error' },
  theme: { default: 'dark' }
};

// Load based on environment
const config = process.env.NODE_ENV === 'production'
  ? prodConfig
  : devConfig;

const aether = new AetherCore(config);
```

### Runtime Configuration

```javascript
// Get configuration value
const appName = aether.config.get('app.name');

// Set configuration value
aether.config.set('logging.level', 'debug');

// Get entire config object
const fullConfig = aether.config.getAll();

// Merge configuration
aether.config.merge({
  logging: { enableFile: false }
});
```

## 🔍 Troubleshooting

### Common Issues

#### Module Not Loading

**Problem**: Module appears in the module list but doesn't initialize.

**Solution**:
```javascript
// Check module status
const module = aether.moduleManager.getModule('module-name');
console.log('Module enabled:', module.enabled);
console.log('Module errors:', module.errors);

// Enable verbose logging
aether.config.set('logging.level', 'debug');

// Manually reinitialize
await aether.moduleManager.reload('module-name');
```

#### Theme Not Applying

**Problem**: Custom theme colors not showing up.

**Solution**:
```javascript
// Verify theme was loaded
const currentTheme = aether.themeManager.getCurrentTheme();
console.log('Current theme:', currentTheme.name);

// Check theme colors
console.log('Theme colors:', currentTheme.colors);

// Force theme refresh
await aether.themeManager.refreshCurrentTheme();
```

#### Events Not Being Emitted

**Problem**: Event listeners not receiving emitted events.

**Solution**:
```javascript
// Verify listener is registered
const hasListener = aether.eventBus.hasListeners('event-name');
console.log('Has listeners:', hasListener);

// Check if event is being emitted
aether.on('*', (eventName, data) => {
  console.log('Event emitted:', eventName, data);
});

// Verify event name spelling
aether.emit('correct-event-name', {});
```

#### High Memory Usage

**Problem**: Application consuming excessive memory.

**Solution**:
```javascript
// Clear old events
aether.dataTracker.clearEvents();

// Disable unnecessary modules
aether.moduleManager.disable('performance');

// Check for memory leaks
aether.on('*', () => {}); // Remove global listener
aether.eventBus.removeAllListeners();

// Configure tracking limits
aether.config.set('tracking.maxEvents', 500);
```

#### Configuration Not Loading

**Problem**: Configuration values not being read correctly.

**Solution**:
```javascript
// Verify config file exists
const config = await aether.config.loadFile('./aethercore.config.js');

// Check environment variables
console.log('Environment:', process.env.NODE_ENV);

// Reset to defaults
aether.config.reset();
aether.config.merge(defaultConfig);
```

### Debug Mode

```javascript
// Enable debug mode
const aether = new AetherCore({
  debug: true,
  logging: { level: 'debug' }
});

// Access debug information
const debugInfo = aether.getDebugInfo();
console.log(debugInfo);

// Performance profiling
aether.performance.startProfiling('operation-name');
// ... perform operations ...
const duration = aether.performance.endProfiling('operation-name');
console.log(`Operation took ${duration}ms`);
```

## 🤝 Contributing

We welcome contributions from the community! Please follow these guidelines:

### Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/AetherCore.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Run tests: `npm run test`
6. Commit your changes: `git commit -am 'Add your feature'`
7. Push to the branch: `git push origin feature/your-feature-name`
8. Submit a Pull Request

### Code Standards

- Follow the existing code style
- Use TypeScript for all new code
- Write unit tests for new features
- Update documentation for any changes
- Keep commits atomic and well-described

### Development Setup

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Run tests
npm run test

# Run linter
npm run lint

# Build for production
npm run build

# Generate documentation
npm run docs
```

### Testing

```bash
# Run all tests
npm test

# Run tests with coverage
npm run test:coverage

# Run specific test file
npm test -- path/to/test.spec.js

# Watch mode
npm run test:watch
```

### Reporting Issues

When reporting issues, please include:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Environment details (Node version, OS, etc.)
- Relevant code snippets
- Error logs or stack traces

## 🗺️ Roadmap

### Version 1.1.0 (Q1 2025)
- [ ] WebSocket support for real-time events
- [ ] Plugin marketplace integration
- [ ] Advanced caching system
- [ ] Performance optimization utilities
- [ ] Extended theme customization

### Version 1.2.0 (Q2 2025)
- [ ] Database abstraction layer
- [ ] Authentication & authorization system
- [ ] API gateway functionality
- [ ] Distributed tracing support
- [ ] Advanced analytics dashboard

### Version 2.0.0 (Q3 2025)
- [ ] Microservices architecture support
- [ ] Kubernetes integration
- [ ] Advanced security features
- [ ] Machine learning model support
- [ ] Serverless function support

### Version 2.1.0 (Q4 2025)
- [ ] GraphQL integration
- [ ] Real-time collaboration features
- [ ] Advanced state synchronization
- [ ] Plugin auto-update system
- [ ] Cloud deployment tools

## 💬 Support

### Documentation
- [Full Documentation](https://docs.aethercore.dev)
- [API Reference](https://docs.aethercore.dev/api)
- [Examples](https://github.com/JugoBetrugoTV/AetherCore/tree/main/examples)
- [FAQ](https://docs.aethercore.dev/faq)

### Community
- [Discord Server](https://discord.gg/aethercore)
- [GitHub Discussions](https://github.com/JugoBetrugoTV/AetherCore/discussions)
- [Stack Overflow Tag](https://stackoverflow.com/questions/tagged/aethercore)
- [Twitter](https://twitter.com/aethercore)

### Getting Help
- 📧 Email: support@aethercore.dev
- 🐛 Report Issues: [GitHub Issues](https://github.com/JugoBetrugoTV/AetherCore/issues)
- 💡 Feature Requests: [GitHub Discussions](https://github.com/JugoBetrugoTV/AetherCore/discussions)

## 📄 License

AetherCore is released under the MIT License. See the [LICENSE](LICENSE) file for complete details.

```
MIT License

Copyright (c) 2024-2025 JugoBetrugoTV

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

## 👤 Author

**JugoBetrugoTV**
- GitHub: [@JugoBetrugoTV](https://github.com/JugoBetrugoTV)
- Email: jugoberugo@example.com
- Website: [www.jugoberugo.dev](https://www.jugoberugo.dev)

### Acknowledgments

Special thanks to all contributors and community members who have helped make AetherCore better through feedback, bug reports, and contributions.

---

**Made with ❤️ by JugoBetrugoTV**

If you find AetherCore useful, please consider:
- ⭐ Starring the repository
- 🔄 Sharing with others
- 💬 Providing feedback
- 🤝 Contributing code or documentation
- ☕ [Sponsoring the project](https://github.com/sponsors/JugoBetrugoTV)
