`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [1:0] x;
    wire [1:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase001: Input 2'b11");
            reset_dut();


            x = 2'b11;
            @(posedge clk);


            x = 2'b00;
            @(posedge clk);

            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase002: Input 2'b10");
            reset_dut();

            x = 2'b10;
            @(posedge clk);
            x = 2'b11;
            @(posedge clk);

            #1 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase003: Input 2'b01");
            reset_dut();

            x = 2'b01;
            @(posedge clk);
            x = 2'b10;
            @(posedge clk);

            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase004: Input 2'b00 after high reset");
            reset_dut();


            x = 2'b00;
            @(posedge clk);
            x = 2'b11;
            @(posedge clk);

            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase005: Verifying exactly 2-cycle latency");
            reset_dut();

            x = 2'b11;
            @(posedge clk);

            #1;
            if (y === 2'b11) begin
                $display("FAIL: Output changed in 1 cycle, expected 2.");
                fail_count = fail_count + 1;
            end else begin

                @(posedge clk);
                #1 #1;
 check_outputs(2'b11);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deadbeat_controller Testbench");
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
        input [1:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, rst, x, y);
    end

endmodule
