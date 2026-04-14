`timescale 1ns/1ps

module slam_update_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] map_update;
    reg [4:0] position_in;
    reg rst;
    wire [7:0] map_out;
    wire [4:0] position_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_update dut (
        .clk(clk),
        .map_update(map_update),
        .position_in(position_in),
        .rst(rst),
        .map_out(map_out),
        .position_out(position_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        position_in = 0;
        map_update = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking reset state", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Standard update (small values)", test_num);
        reset_dut();
        position_in = 5'h05;
        map_update = 8'hA2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA2, 5'h05);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum input values", test_num);
        reset_dut();
        position_in = 5'h1F;
        map_update = 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF, 5'h1F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bit patterns", test_num);
        reset_dut();
        position_in = 5'h0A;
        map_update = 8'h55;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55, 5'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary check for position", test_num);
        reset_dut();
        position_in = 5'h10;
        map_update = 8'h0F;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h0F, 5'h10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_update Testbench");
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
        input [7:0] expected_map_out;
        input [4:0] expected_position_out;
        begin
            if (expected_map_out === (expected_map_out ^ map_out ^ expected_map_out) &&
                expected_position_out === (expected_position_out ^ position_out ^ expected_position_out)) begin
                $display("PASS");
                $display("  Outputs: map_out=%h, position_out=%h",
                         map_out, position_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: map_out=%h, position_out=%h",
                         expected_map_out, expected_position_out);
                $display("  Got:      map_out=%h, position_out=%h",
                         map_out, position_out);
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
        $dumpvars(0,clk, map_update, position_in, rst, map_out, position_out);
    end

endmodule
