`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] prescaler;
    reg strobe;
    reg [7:0] tx_in;
    wire busy;
    wire prefetch;
    wire txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx dut (
        .clk(clk),
        .prescaler(prescaler),
        .strobe(strobe),
        .tx_in(tx_in),
        .busy(busy),
        .prefetch(prefetch),
        .txd(txd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            strobe = 0;
            tx_in = 8'h00;
            prescaler = 8'h01;
            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Basic transmission 0x55, Prescaler 5", test_num);
            reset_dut();

            prescaler = 8'd5;
            tx_in = 8'h55;
            strobe = 1;
            @(posedge clk);
            #1 strobe = 0;


            wait(busy == 1);
            wait(busy == 0);


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %02d: Transmitting 0x00, Prescaler 2", test_num);
            reset_dut();

            prescaler = 8'd2;
            tx_in = 8'h00;
            strobe = 1;
            @(posedge clk);
            #1 strobe = 0;

            wait(busy == 1);
            wait(busy == 0);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Transmitting 0xFF, Prescaler 3", test_num);
            reset_dut();

            prescaler = 8'd3;
            tx_in = 8'hFF;
            strobe = 1;
            @(posedge clk);
            #1 strobe = 0;

            wait(busy == 1);
            wait(busy == 0);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Sequential transmission (Prefetch Check)", test_num);
            reset_dut();

            prescaler = 8'd4;

            tx_in = 8'hA5;
            strobe = 1;
            @(posedge clk);
            #1 strobe = 0;


            wait(prefetch == 1);
            @(posedge clk);


            tx_in = 8'h3C;
            strobe = 1;
            @(posedge clk);
            #1 strobe = 0;


            wait(busy == 1);
            wait(busy == 0);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Slow Transmission (Prescaler 20)", test_num);
            reset_dut();

            prescaler = 8'd20;
            tx_in = 8'h12;
            strobe = 1;
            @(posedge clk);
            #1 strobe = 0;

            wait(busy == 1);
            wait(busy == 0);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_busy;
        input expected_prefetch;
        input expected_txd;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_prefetch === (expected_prefetch ^ prefetch ^ expected_prefetch) &&
                expected_txd === (expected_txd ^ txd ^ expected_txd)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, prefetch=%b, txd=%b",
                         busy, prefetch, txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, prefetch=%b, txd=%b",
                         expected_busy, expected_prefetch, expected_txd);
                $display("  Got:      busy=%b, prefetch=%b, txd=%b",
                         busy, prefetch, txd);
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
        $dumpvars(0,clk, prescaler, strobe, tx_in, busy, prefetch, txd);
    end

endmodule
