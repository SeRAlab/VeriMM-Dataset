`timescale 1ns/1ps

module pcie_endpoint_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg data_in_valid;
    reg reset;
    wire [31:0] data_out;
    wire data_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint dut (
        .clk(clk),
        .data_in(data_in),
        .data_in_valid(data_in_valid),
        .reset(reset),
        .data_out(data_out),
        .data_out_valid(data_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 32'h0;
            data_in_valid = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Data Transmission", test_num);
            reset_dut();


            data_in = 32'hABCD1234;
            data_in_valid = 1;
            @(posedge clk);
            #1 data_in_valid = 0;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'hABCD1234, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Transfers", test_num);
            reset_dut();


            data_in = 32'h11112222;
            data_in_valid = 1;
            @(posedge clk);


            #1 data_in = 32'h33334444;
            data_in_valid = 1;
            @(posedge clk);

            #1 data_in_valid = 0;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'h33334444, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid Signal Gating", test_num);
            reset_dut();


            data_in = 32'h55556666;
            data_in_valid = 0;
            @(posedge clk);

            repeat(2) @(posedge clk);


            #1;



            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Value Transfer", test_num);
            reset_dut();

            data_in = 32'hFFFFFFFF;
            data_in_valid = 1;
            @(posedge clk);
            #1 data_in_valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint Testbench");
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
        input expected_data_out_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_out_valid === (expected_data_out_valid ^ data_out_valid ^ expected_data_out_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_out_valid=%b",
                         data_out, data_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_out_valid=%b",
                         expected_data_out, expected_data_out_valid);
                $display("  Got:      data_out=%h, data_out_valid=%b",
                         data_out, data_out_valid);
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
        $dumpvars(0,clk, data_in, data_in_valid, reset, data_out, data_out_valid);
    end

endmodule
