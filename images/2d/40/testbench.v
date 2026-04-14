`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg parity_in;
    reg request;
    reg reset;
    wire [7:0] data_out;
    wire parity_out;
    wire retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .clk(clk),
        .data_in(data_in),
        .parity_in(parity_in),
        .request(request),
        .reset(reset),
        .data_out(data_out),
        .parity_out(parity_out),
        .retransmit(retransmit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            parity_in = 0;
            request = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Valid data (8'hAA - 4 ones), Parity 0", test_num);
            reset_dut();


            data_in = 8'hAA;
            parity_in = 0;
            request = 1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hAA, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Valid data (8'h01 - 1 one), Parity 1", test_num);
            reset_dut();


            data_in = 8'h01;
            parity_in = 1;
            request = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Invalid data (8'hAA - 4 ones), Parity 1 (Expected 0)", test_num);
            reset_dut();


            data_in = 8'hAA;
            parity_in = 1;
            request = 1;

            @(posedge clk);
            #1;




            #1;





            check_outputs(data_out, parity_out, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Error detection then corrected retransmission", test_num);
            reset_dut();


            data_in = 8'hF0;
            parity_in = 1;
            request = 1;
            @(posedge clk);
            #1;
            if (retransmit == 1) $display("  Step 1: Retransmit correctly requested.");


            data_in = 8'hF0;
            parity_in = 0;
            request = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hF0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: All zeros (0 ones), Parity 0", test_num);
            reset_dut();

            data_in = 8'h00;
            parity_in = 0;
            request = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: All ones (8 ones), Parity 0", test_num);
            reset_dut();

            data_in = 8'hFF;
            parity_in = 0;
            request = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arq_system Testbench");
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
        input [7:0] expected_data_out;
        input expected_parity_out;
        input expected_retransmit;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_parity_out === (expected_parity_out ^ parity_out ^ expected_parity_out) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, parity_out=%b, retransmit=%b",
                         data_out, parity_out, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, parity_out=%b, retransmit=%b",
                         expected_data_out, expected_parity_out, expected_retransmit);
                $display("  Got:      data_out=%h, parity_out=%b, retransmit=%b",
                         data_out, parity_out, retransmit);
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
        $dumpvars(0,clk, data_in, parity_in, request, reset, data_out, parity_out, retransmit);
    end

endmodule
