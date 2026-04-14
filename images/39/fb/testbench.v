`timescale 1ns/1ps

module divide_by_8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divide_by_8 dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;

            if (data_out !== 8'h0) begin
                $display("Error: data_out not reset to 0");
            end
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic division (8 / 8)", test_num);
            reset_dut();
            data_in = 8'd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division by zero-like (0 / 8)", test_num);
            reset_dut();
            data_in = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value (255 / 8)", test_num);
            reset_dut();
            data_in = 8'd255;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Value less than 8 (7 / 8)", test_num);
            reset_dut();
            data_in = 8'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Non-multiple of 8 (19 / 8)", test_num);
            reset_dut();
            data_in = 8'd19;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large multiple of 8 (160 / 8)", test_num);
            reset_dut();
            data_in = 8'd160;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary value (15 / 8)", test_num);
            reset_dut();
            data_in = 8'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divide_by_8 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, data_out);
    end

endmodule
