`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire ack;
    wire data_out;
    wire nack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .ack(ack),
        .data_out(data_out),
        .nack(nack)
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Post-Reset Initialization", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmit Data Bit 0", test_num);
            reset_dut();
            data_in = 0;



            while (ack !== 1) begin
                @(posedge clk);
                #1;
                if (nack) $display("  [Time %0t] NACK received, sender should be retrying...", $time);
            end


            #1;



            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmit Data Bit 1", test_num);
            reset_dut();
            data_in = 1;


            while (ack !== 1) begin
                @(posedge clk);
                #1;
                if (nack) $display("  [Time %0t] NACK received, sender should be retrying...", $time);
            end


            #1;



            check_outputs(1, 1, 0);
        end
        endtask

    task testcase004;

        integer timeout_count;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reliability Check", test_num);
            reset_dut();
            data_in = 1;
            timeout_count = 0;


            while (ack !== 1 && timeout_count < 50) begin
                @(posedge clk);
                timeout_count = timeout_count + 1;
            end

            if (timeout_count >= 50) begin
                $display("FAIL: System timed out without sending ACK");
                fail_count = fail_count + 1;
            end else begin
                #1;

                check_outputs(1, 1, 0);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Transition Check", test_num);
            reset_dut();


            data_in = 0;
            wait(ack == 1);
            @(posedge clk); #1;


            data_in = 1;
            while (ack !== 1) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(1, 1, 0);
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
        input expected_data_out;
        input expected_nack;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_nack === (expected_nack ^ nack ^ expected_nack)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%b, nack=%b",
                         ack, data_out, nack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%b, nack=%b",
                         expected_ack, expected_data_out, expected_nack);
                $display("  Got:      ack=%b, data_out=%b, nack=%b",
                         ack, data_out, nack);
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
        $dumpvars(0,clk, data_in, reset, ack, data_out, nack);
    end

endmodule
