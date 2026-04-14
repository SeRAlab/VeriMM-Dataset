`timescale 1ns/1ps

module vga_split_controller_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg hsync;
    reg [15:0] rgb_0;
    reg [15:0] rgb_1;
    wire [15:0] rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vga_split_controller dut (
        .clock(clock),
        .hsync(hsync),
        .rgb_0(rgb_0),
        .rgb_1(rgb_1),
        .rgb(rgb)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        hsync = 0;
        rgb_0 = 0;
        rgb_1 = 0;
        repeat(5) @(posedge clock);
    end
        endtask
    task simulate_line;

        input integer duration_ns;
        begin
            hsync = 1;
            #20;
            hsync = 0;
            #(duration_ns - 20);
        end
        endtask

    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case 001: Standard resolution (1000ns line), checking left half...");

        simulate_line(1000);

        hsync = 1; #20; hsync = 0;
        rgb_0 = 16'hAAAA;
        rgb_1 = 16'h5555;
        #250;
        @(posedge clock);
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case 002: Standard resolution (1000ns line), checking right half...");

        simulate_line(1000);

        hsync = 1; #20; hsync = 0;
        rgb_0 = 16'hAAAA;
        rgb_1 = 16'h5555;
        #750;
        @(posedge clock);
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case 003: Short resolution (600ns line), checking left half...");

        simulate_line(600);

        hsync = 1; #20; hsync = 0;
        rgb_0 = 16'hF800;
        rgb_1 = 16'h07E0;
        #150;
        @(posedge clock);
        #1;

        check_outputs(16'hF800);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case 004: Short resolution (600ns line), checking right half...");

        simulate_line(600);

        hsync = 1; #20; hsync = 0;
        rgb_0 = 16'hF800;
        rgb_1 = 16'h07E0;
        #450;
        @(posedge clock);
        #1;

        check_outputs(16'h07E0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case 005: Data integrity check with unique 16-bit values...");

        simulate_line(1000);

        hsync = 1; #20; hsync = 0;
        rgb_0 = 16'h1234;
        rgb_1 = 16'hABCD;
        #800;
        @(posedge clock);
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vga_split_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [15:0] expected_rgb;
        begin
            if (expected_rgb === (expected_rgb ^ rgb ^ expected_rgb)) begin
                $display("PASS");
                $display("  Outputs: rgb=%h",
                         rgb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb=%h",
                         expected_rgb);
                $display("  Got:      rgb=%h",
                         rgb);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clock, hsync, rgb_0, rgb_1, rgb);
    end

endmodule
