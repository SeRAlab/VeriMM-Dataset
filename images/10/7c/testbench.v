`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    reg valid;
    wire ack;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .ack(ack),
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
            valid = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Successful Frame Transfer", test_num);
            reset_dut();

            data_in = 4'hA;
            valid = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Erroneous Frame then Successful Retransmission", test_num);
            reset_dut();


            data_in = 4'h5;
            valid = 0;
            @(posedge clk);
            #2;


            if (ack !== 1'b0) begin
                $display("Intermediate Step FAIL: Ack should be low for invalid frame");
            end


            data_in = 4'h5;
            valid = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Sequential Successful Frames", test_num);
            reset_dut();


            data_in = 4'h1; valid = 1;
            @(posedge clk);
            #1;


            data_in = 4'hB; valid = 1;
            @(posedge clk);
            #1;


            data_in = 4'hF; valid = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Retransmission Attempts", test_num);
            reset_dut();

            data_in = 4'hC;
            valid = 0;
            @(posedge clk);
            #1;

            valid = 0;
            @(posedge clk);
            #1;

            valid = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State After Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'h0);
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
        input expected_ack;
        input [3:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%b, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, data_in, reset, valid, ack, data_out);
    end

endmodule
