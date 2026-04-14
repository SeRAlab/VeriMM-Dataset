`timescale 1ns/1ps

module ethernet_mac_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg tx_en;
    wire [7:0] data_out;
    wire tx_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_tx dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .tx_en(tx_en),
        .data_out(data_out),
        .tx_complete(tx_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            tx_en = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Transmission (0xAA)", test_num);
            reset_dut();

            data_in = 8'hAA;
            tx_en = 1;
            @(posedge clk);
            #1;

            tx_en = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Latching Verification", test_num);
            reset_dut();

            data_in = 8'h55;
            tx_en = 1;
            @(posedge clk);
            #1;


            data_in = 8'hFF;
            @(posedge clk);
            #1;

            tx_en = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Data Transmission", test_num);
            reset_dut();

            data_in = 8'h00;
            tx_en = 1;
            @(posedge clk);
            #1;

            tx_en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-cycle Transmission", test_num);
            reset_dut();

            data_in = 8'hBE;
            tx_en = 1;
            repeat(5) @(posedge clk);
            #1;

            tx_en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hBE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset During Transmission", test_num);
            reset_dut();

            data_in = 8'h12;
            tx_en = 1;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_tx Testbench");
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
        input [7:0] expected_data_out;
        input expected_tx_complete;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_tx_complete === (expected_tx_complete ^ tx_complete ^ expected_tx_complete)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, tx_complete=%b",
                         data_out, tx_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, tx_complete=%b",
                         expected_data_out, expected_tx_complete);
                $display("  Got:      data_out=%h, tx_complete=%b",
                         data_out, tx_complete);
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
        $dumpvars(0,clk, data_in, rst, tx_en, data_out, tx_complete);
    end

endmodule
