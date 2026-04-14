`timescale 1ns/1ps

module uart_receiver_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] baud_divisor;
    reg clk;
    reg clk_en;
    reg reset_n;
    reg rx_char_ready;
    reg rxd;
    wire source_rxd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_receiver dut (
        .baud_divisor(baud_divisor),
        .clk(clk),
        .clk_en(clk_en),
        .reset_n(reset_n),
        .rx_char_ready(rx_char_ready),
        .rxd(rxd),
        .source_rxd(source_rxd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            baud_divisor = 16'h0;
            clk_en = 0;
            rx_char_ready = 0;
            rxd = 1;
            #20;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: rxd = 0 pass-through", test_num);
            reset_dut();
            rxd = 0;
            baud_divisor = 16'hFFFF;
            clk_en = 1;
            rx_char_ready = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: rxd = 1 pass-through", test_num);
            reset_dut();
            rxd = 1;
            baud_divisor = 16'h1234;
            clk_en = 1;
            rx_char_ready = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: rxd = 0 with clk_en low", test_num);
            reset_dut();
            rxd = 0;
            clk_en = 0;
            baud_divisor = 16'h0001;
            rx_char_ready = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify logic after multiple cycles", test_num);
            reset_dut();
            rxd = 0;
            @(posedge clk);
            rxd = 1;
            @(posedge clk);
            rxd = 0;
            baud_divisor = 16'hAAAA;
            clk_en = 1;
            rx_char_ready = 0;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify output during/after reset", test_num);
            reset_n = 0;
            rxd = 1;
            #20;
            reset_n = 1;
            rxd = 1;
            baud_divisor = 16'h5555;
            clk_en = 1;
            @(posedge clk);
            #2;
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
        $display("uart_receiver Testbench");
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
        input expected_source_rxd;
        begin
            if (expected_source_rxd === (expected_source_rxd ^ source_rxd ^ expected_source_rxd)) begin
                $display("PASS");
                $display("  Outputs: source_rxd=%b",
                         source_rxd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: source_rxd=%b",
                         expected_source_rxd);
                $display("  Got:      source_rxd=%b",
                         source_rxd);
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
        $dumpvars(0,baud_divisor, clk, clk_en, reset_n, rx_char_ready, rxd, source_rxd);
    end

endmodule
