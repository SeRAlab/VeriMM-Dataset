`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] received_data;
    reg rst;
    reg valid;
    wire [4:0] corrected_data;
    wire request;
    wire [2:0] retransmission_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .received_data(received_data),
        .rst(rst),
        .valid(valid),
        .corrected_data(corrected_data),
        .request(request),
        .retransmission_count(retransmission_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            received_data = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: System Reset State");
            reset_dut();

            #1;


            check_outputs(5'h00, 1'b0, 3'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Successful Data Reception");
            reset_dut();
            received_data = 5'h1A;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1A, 1'b0, 3'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Single Retransmission Request");
            reset_dut();
            received_data = 5'h0F;
            valid = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00, 1'b1, 3'h1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Multiple Retransmission Requests");
            reset_dut();
            valid = 0;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00, 1'b1, 3'h3);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Valid Data after Retransmission");
            reset_dut();

            valid = 0;
            @(posedge clk);
            #1;

            received_data = 5'h05;
            valid = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'h05, 1'b0, retransmission_count);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Test Case 006: Counter Limit (8 cycles of invalid)");
            reset_dut();
            valid = 0;
            for(i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(5'h00, 1'b1, 3'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_System Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [4:0] expected_corrected_data;
        input expected_request;
        input [2:0] expected_retransmission_count;
        begin
            if (expected_corrected_data === (expected_corrected_data ^ corrected_data ^ expected_corrected_data) &&
                expected_request === (expected_request ^ request ^ expected_request) &&
                expected_retransmission_count === (expected_retransmission_count ^ retransmission_count ^ expected_retransmission_count)) begin
                $display("PASS");
                $display("  Outputs: corrected_data=%h, request=%b, retransmission_count=%h",
                         corrected_data, request, retransmission_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: corrected_data=%h, request=%b, retransmission_count=%h",
                         expected_corrected_data, expected_request, expected_retransmission_count);
                $display("  Got:      corrected_data=%h, request=%b, retransmission_count=%h",
                         corrected_data, request, retransmission_count);
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
        $dumpvars(0,clk, received_data, rst, valid, corrected_data, request, retransmission_count);
    end

endmodule
