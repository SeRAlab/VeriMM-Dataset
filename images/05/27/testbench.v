`timescale 1ns/1ps

module ARQ_system_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] checksum_in;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire request_resend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_system dut (
        .checksum_in(checksum_in),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .request_resend(request_resend)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h0;
            checksum_in = 8'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Valid Data and Matching Checksum", test_num);
            reset_dut();
            data_in = 8'hA5;
            checksum_in = 8'hA5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Data and Checksum Mismatch", test_num);
            reset_dut();
            data_in = 8'hA5;
            checksum_in = 8'h5A;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: All Zeros Match", test_num);
            reset_dut();
            data_in = 8'h00;
            checksum_in = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: All Ones Match", test_num);
            reset_dut();
            data_in = 8'hFF;
            checksum_in = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Single Bit Mismatch", test_num);
            reset_dut();
            data_in = 8'h80;
            checksum_in = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Sequential Check (Good then Bad)", test_num);
            reset_dut();


            data_in = 8'h12;
            checksum_in = 8'h12;
            @(posedge clk);


            data_in = 8'h34;
            checksum_in = 8'h00;
            @(posedge clk);

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Reset Stability", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_system Testbench");
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
        input expected_request_resend;
        begin
            if (expected_request_resend === (expected_request_resend ^ request_resend ^ expected_request_resend)) begin
                $display("PASS");
                $display("  Outputs: request_resend=%b",
                         request_resend);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: request_resend=%b",
                         expected_request_resend);
                $display("  Got:      request_resend=%b",
                         request_resend);
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
        $dumpvars(0,checksum_in, clk, data_in, rst, request_resend);
    end

endmodule
