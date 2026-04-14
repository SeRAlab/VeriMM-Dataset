`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst_n;
    reg valid_in;
    wire [31:0] data_out;
    wire ready_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_out(data_out),
        .ready_out(ready_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            valid_in = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Data Packet", test_num);
            reset_dut();

            data_in = 32'hDEADBEEF;
            valid_in = 1'b1;
            @(posedge clk);
            #1;

            valid_in = 1'b0;
            data_in = 32'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum Data Value", test_num);
            reset_dut();

            data_in = 32'hFFFFFFFF;
            valid_in = 1'b1;
            @(posedge clk);
            #1;

            valid_in = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Data Value", test_num);
            reset_dut();

            data_in = 32'h00000000;
            valid_in = 1'b1;
            @(posedge clk);
            #1;

            valid_in = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Idle state (No valid_in)", test_num);
            reset_dut();

            data_in = 32'hAAAA5555;
            valid_in = 1'b0;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating Bit Pattern", test_num);
            reset_dut();

            data_in = 32'h5A5A5A5A;
            valid_in = 1'b1;
            @(posedge clk);
            #1;

            valid_in = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h5A5A5A5A, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input [31:0] expected_data_out;
        input expected_ready_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready_out === (expected_ready_out ^ ready_out ^ expected_ready_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready_out=%b",
                         data_out, ready_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready_out=%b",
                         expected_data_out, expected_ready_out);
                $display("  Got:      data_out=%h, ready_out=%b",
                         data_out, ready_out);
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
        $dumpvars(0,clk, data_in, rst_n, valid_in, data_out, ready_out);
    end

endmodule
