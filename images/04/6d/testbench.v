`timescale 1ns/1ps

module pcie_packet_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] request_data;
    reg reset;
    reg valid_in;
    wire [31:0] response_data;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_packet_processor dut (
        .clk(clk),
        .request_data(request_data),
        .reset(reset),
        .valid_in(valid_in),
        .response_data(response_data),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_in = 0;
            request_data = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Basic Increment", test_num);
            reset_dut();

            @(posedge clk);
            valid_in <= 1;
            request_data <= 32'h0000_000A;

            @(posedge clk);
            valid_in <= 0;
            request_data <= 32'h0;

            @(posedge clk);

            #1;
            #1;

            check_outputs(32'h0000_000B, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Wrap-around Check", test_num);
            reset_dut();

            @(posedge clk);
            valid_in <= 1;
            request_data <= 32'hFFFF_FFFF;

            @(posedge clk);
            valid_in <= 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: No Valid Input", test_num);
            reset_dut();

            @(posedge clk);
            valid_in <= 0;
            request_data <= 32'h1234_5678;

            repeat(2) @(posedge clk);

            #1;

            #1;


            check_outputs(response_data, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Zero Data Increment", test_num);
            reset_dut();

            @(posedge clk);
            valid_in <= 1;
            request_data <= 32'h0000_0000;

            @(posedge clk);
            valid_in <= 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0001, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Arbitrary Data", test_num);
            reset_dut();

            @(posedge clk);
            valid_in <= 1;
            request_data <= 32'h55AA_1234;

            @(posedge clk);
            valid_in <= 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55AA_1235, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_packet_processor Testbench");
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
        input [31:0] expected_response_data;
        input expected_valid_out;
        begin
            if (expected_response_data === (expected_response_data ^ response_data ^ expected_response_data) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: response_data=%h, valid_out=%b",
                         response_data, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: response_data=%h, valid_out=%b",
                         expected_response_data, expected_valid_out);
                $display("  Got:      response_data=%h, valid_out=%b",
                         response_data, valid_out);
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
        $dumpvars(0,clk, request_data, reset, valid_in, response_data, valid_out);
    end

endmodule
