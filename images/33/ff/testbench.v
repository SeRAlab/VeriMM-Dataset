`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg start;
    wire tx_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx dut (
        .clk(clk),
        .data(data),
        .start(start),
        .tx_out(tx_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data = 8'h00;

            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: LSB (Data bit 0) set to 1", test_num);
            data = 8'h01;
            start = 1;
            @(posedge clk);
            start = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: LSB (Data bit 0) set to 0", test_num);
            data = 8'hFE;
            start = 1;
            @(posedge clk);
            start = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Verify bit 3 is sent correctly", test_num);
            data = 8'h08;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: MSB (Data bit 7) set to 1", test_num);
            data = 8'h80;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: MSB (Data bit 7) set to 0", test_num);
            data = 8'h7F;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Stop Bit (Logic 1) after 8 data bits (0x00)", test_num);
            data = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Stop Bit (Logic 1) after 8 data bits (0xFF)", test_num);
            data = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_tx Testbench");
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
        input expected_tx_out;
        begin
            if (expected_tx_out === (expected_tx_out ^ tx_out ^ expected_tx_out)) begin
                $display("PASS");
                $display("  Outputs: tx_out=%b",
                         tx_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_out=%b",
                         expected_tx_out);
                $display("  Got:      tx_out=%b",
                         tx_out);
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
        $dumpvars(0,clk, data, start, tx_out);
    end

endmodule
