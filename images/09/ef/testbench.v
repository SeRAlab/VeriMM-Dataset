`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg tx_enable;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .tx_enable(tx_enable),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            tx_enable = 0;
            data_in = 8'h00;
            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            reset_dut();
            test_val = 8'h55;
            data_in = test_val;
            tx_enable = 1;

            @(posedge clk);
            #1;
            tx_enable = 0;


            #1;



            check_outputs(1'b0);


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(test_val[i]);
            end


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            reset_dut();
            test_val = 8'hAA;
            data_in = test_val;
            tx_enable = 1;

            @(posedge clk);
            #1;
            tx_enable = 0;


            #1;



            check_outputs(1'b0);


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(test_val[i]);
            end


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            reset_dut();
            test_val = 8'h00;
            data_in = test_val;
            tx_enable = 1;

            @(posedge clk);
            #1;
            tx_enable = 0;

            #1;


            check_outputs(1'b0);
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(test_val[i]);
            end
            #1;

            check_outputs(1'b1);
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            reset_dut();
            test_val = 8'hFF;
            data_in = test_val;
            tx_enable = 1;

            @(posedge clk);
            #1;
            tx_enable = 0;

            #1;


            check_outputs(1'b0);
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(test_val[i]);
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            reset_dut();
            test_val = 8'hA5;
            data_in = test_val;
            tx_enable = 1;

            @(posedge clk);
            #1;
            tx_enable = 0;

            #1;


            check_outputs(1'b0);
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(test_val[i]);
            end
            @(posedge clk);
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
        $display("uart_transmitter Testbench");
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
        input expected_tx;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: tx=%b",
                         tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b",
                         expected_tx);
                $display("  Got:      tx=%b",
                         tx);
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
        $dumpvars(0,clk, data_in, tx_enable, tx);
    end

endmodule
