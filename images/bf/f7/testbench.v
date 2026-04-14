`timescale 1ns/1ps

module deppbyte_tb;

    // Testbench signals (sequential circuit)
    reg i_astb_n;
    reg i_clk;
    reg [7:0] i_depp;
    reg i_dstb_n;
    reg [7:0] i_tx_data;
    reg i_tx_stb;
    reg i_write_n;
    wire [7:0] o_depp;
    wire [7:0] o_rx_data;
    wire o_rx_stb;
    wire o_tx_busy;
    wire o_wait;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deppbyte dut (
        .i_astb_n(i_astb_n),
        .i_clk(i_clk),
        .i_depp(i_depp),
        .i_dstb_n(i_dstb_n),
        .i_tx_data(i_tx_data),
        .i_tx_stb(i_tx_stb),
        .i_write_n(i_write_n),
        .o_depp(o_depp),
        .o_rx_data(o_rx_data),
        .o_rx_stb(o_rx_stb),
        .o_tx_busy(o_tx_busy),
        .o_wait(o_wait)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_astb_n = 1;
            i_dstb_n = 1;
            i_write_n = 1;
            i_depp = 8'h00;
            i_tx_stb = 0;
            i_tx_data = 8'h00;
            repeat (2) @(posedge i_clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Address Strobe Operation");
            reset_dut();


            i_depp = 8'hA5;
            i_astb_n = 0;
            @(posedge i_clk);
            #1;



            i_astb_n = 1;
            repeat (2) @(posedge i_clk);



            #1;




            check_outputs(8'h00, 8'h00, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Data Write Operation");
            reset_dut();


            i_depp = 8'h5A;
            i_write_n = 0;
            i_dstb_n = 0;

            @(posedge i_clk);


            i_dstb_n = 1;
            i_write_n = 1;

            repeat (1) @(posedge i_clk);


            #1;



            check_outputs(8'h00, 8'h5A, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Transmit Data Load");
            reset_dut();


            i_tx_data = 8'hC3;
            i_tx_stb = 1;
            @(posedge i_clk);
            i_tx_stb = 0;

            repeat (2) @(posedge i_clk);


            #1;



            check_outputs(8'h00, 8'h00, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Data Read Operation");
            reset_dut();


            i_tx_data = 8'h33;
            i_tx_stb = 1;
            @(posedge i_clk);
            i_tx_stb = 0;
            @(posedge i_clk);


            i_write_n = 1;
            i_dstb_n = 0;


            repeat (2) @(posedge i_clk);


            i_dstb_n = 1;
            repeat (2) @(posedge i_clk);



            #1;




            check_outputs(8'h33, 8'h00, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Full Sequence");
            reset_dut();


            i_depp = 8'h01;
            i_astb_n = 0; @(posedge i_clk); i_astb_n = 1; @(posedge i_clk);


            i_depp = 8'hEE;
            i_write_n = 0; i_dstb_n = 0; @(posedge i_clk); i_dstb_n = 1; i_write_n = 1; @(posedge i_clk);


            i_tx_data = 8'h77;
            i_tx_stb = 1; @(posedge i_clk); i_tx_stb = 0; @(posedge i_clk);


            i_write_n = 1; i_dstb_n = 0; @(posedge i_clk); i_dstb_n = 1;
            repeat (2) @(posedge i_clk);


            #1;



            check_outputs(8'h77, 8'hEE, 1'b0, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deppbyte Testbench");
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
        input [7:0] expected_o_depp;
        input [7:0] expected_o_rx_data;
        input expected_o_rx_stb;
        input expected_o_tx_busy;
        input expected_o_wait;
        begin
            if (expected_o_depp === (expected_o_depp ^ o_depp ^ expected_o_depp) &&
                expected_o_rx_data === (expected_o_rx_data ^ o_rx_data ^ expected_o_rx_data) &&
                expected_o_rx_stb === (expected_o_rx_stb ^ o_rx_stb ^ expected_o_rx_stb) &&
                expected_o_tx_busy === (expected_o_tx_busy ^ o_tx_busy ^ expected_o_tx_busy) &&
                expected_o_wait === (expected_o_wait ^ o_wait ^ expected_o_wait)) begin
                $display("PASS");
                $display("  Outputs: o_depp=%h, o_rx_data=%h, o_rx_stb=%b, o_tx_busy=%b, o_wait=%b",
                         o_depp, o_rx_data, o_rx_stb, o_tx_busy, o_wait);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_depp=%h, o_rx_data=%h, o_rx_stb=%b, o_tx_busy=%b, o_wait=%b",
                         expected_o_depp, expected_o_rx_data, expected_o_rx_stb, expected_o_tx_busy, expected_o_wait);
                $display("  Got:      o_depp=%h, o_rx_data=%h, o_rx_stb=%b, o_tx_busy=%b, o_wait=%b",
                         o_depp, o_rx_data, o_rx_stb, o_tx_busy, o_wait);
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
        $dumpvars(0,i_astb_n, i_clk, i_depp, i_dstb_n, i_tx_data, i_tx_stb, i_write_n, o_depp, o_rx_data, o_rx_stb, o_tx_busy, o_wait);
    end

endmodule
