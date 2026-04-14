`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CHANNEL_UP;
    reg USER_CLK;
    reg [63:0] s_axi_tx_tdata;
    reg s_axi_tx_tlast;
    reg s_axi_tx_tready;
    reg s_axi_tx_tvalid;
    wire [63:0] TX_PE_DATA;
    wire TX_PE_DATA_V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CHANNEL_UP(CHANNEL_UP),
        .USER_CLK(USER_CLK),
        .s_axi_tx_tdata(s_axi_tx_tdata),
        .s_axi_tx_tlast(s_axi_tx_tlast),
        .s_axi_tx_tready(s_axi_tx_tready),
        .s_axi_tx_tvalid(s_axi_tx_tvalid),
        .TX_PE_DATA(TX_PE_DATA),
        .TX_PE_DATA_V(TX_PE_DATA_V)
    );

    // Clock generation (10ns period)
    initial begin
        USER_CLK = 0;
        forever #5 USER_CLK = ~USER_CLK;
    end

        task reset_dut;

        begin
            CHANNEL_UP = 0;
            s_axi_tx_tdata = 64'h0;
            s_axi_tx_tlast = 0;
            s_axi_tx_tready = 0;
            s_axi_tx_tvalid = 0;
            repeat(5) @(posedge USER_CLK);
            CHANNEL_UP = 1;
            repeat(2) @(posedge USER_CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic single word transmission", test_num);
            reset_dut();

            @(posedge USER_CLK);
            s_axi_tx_tvalid = 1;
            s_axi_tx_tready = 1;
            s_axi_tx_tdata = 64'hAAAA_BBBB_CCCC_DDDD;
            s_axi_tx_tlast = 1;

            @(posedge USER_CLK);
            s_axi_tx_tvalid = 0;
            s_axi_tx_tready = 0;
            s_axi_tx_tlast = 0;


            repeat(2) @(posedge USER_CLK);
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle burst transmission", test_num);
            reset_dut();

            @(posedge USER_CLK);
            s_axi_tx_tvalid = 1;
            s_axi_tx_tready = 1;
            s_axi_tx_tdata = 64'h1111_1111_1111_1111;
            s_axi_tx_tlast = 0;

            @(posedge USER_CLK);
            s_axi_tx_tdata = 64'h2222_2222_2222_2222;

            @(posedge USER_CLK);
            s_axi_tx_tdata = 64'h3333_3333_3333_3333;
            s_axi_tx_tlast = 1;

            @(posedge USER_CLK);
            s_axi_tx_tvalid = 0;
            s_axi_tx_tready = 0;
            s_axi_tx_tlast = 0;

            repeat(2) @(posedge USER_CLK);

            #1;


            check_outputs(64'h3333_3333_3333_3333, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transmission inhibited by ready low", test_num);
            reset_dut();

            @(posedge USER_CLK);
            s_axi_tx_tvalid = 1;
            s_axi_tx_tready = 0;
            s_axi_tx_tdata = 64'hDEAD_BEEF_DEAD_BEEF;

            repeat(3) @(posedge USER_CLK);



            #1;




            check_outputs(TX_PE_DATA, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel Down condition", test_num);
            reset_dut();
            CHANNEL_UP = 0;

            @(posedge USER_CLK);
            s_axi_tx_tvalid = 1;
            s_axi_tx_tready = 1;
            s_axi_tx_tdata = 64'hFFFF_FFFF_FFFF_FFFF;

            repeat(3) @(posedge USER_CLK);

            #1;


            check_outputs(TX_PE_DATA, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid signal toggle during frame", test_num);
            reset_dut();

            @(posedge USER_CLK);
            s_axi_tx_tvalid = 1;
            s_axi_tx_tready = 1;
            s_axi_tx_tdata = 64'h0000_0000_0000_0001;

            @(posedge USER_CLK);
            s_axi_tx_tvalid = 0;
            s_axi_tx_tdata = 64'h0000_0000_0000_0002;

            @(posedge USER_CLK);
            s_axi_tx_tvalid = 1;
            s_axi_tx_tdata = 64'h0000_0000_0000_0003;
            s_axi_tx_tlast = 1;

            @(posedge USER_CLK);
            s_axi_tx_tvalid = 0;
            s_axi_tx_tlast = 0;

            repeat(2) @(posedge USER_CLK);

            #1;


            check_outputs(64'h0000_0000_0000_0003, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [63:0] expected_TX_PE_DATA;
        input expected_TX_PE_DATA_V;
        begin
            if (expected_TX_PE_DATA === (expected_TX_PE_DATA ^ TX_PE_DATA ^ expected_TX_PE_DATA) &&
                expected_TX_PE_DATA_V === (expected_TX_PE_DATA_V ^ TX_PE_DATA_V ^ expected_TX_PE_DATA_V)) begin
                $display("PASS");
                $display("  Outputs: TX_PE_DATA=%h, TX_PE_DATA_V=%b",
                         TX_PE_DATA, TX_PE_DATA_V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TX_PE_DATA=%h, TX_PE_DATA_V=%b",
                         expected_TX_PE_DATA, expected_TX_PE_DATA_V);
                $display("  Got:      TX_PE_DATA=%h, TX_PE_DATA_V=%b",
                         TX_PE_DATA, TX_PE_DATA_V);
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
        $dumpvars(0,CHANNEL_UP, USER_CLK, s_axi_tx_tdata, s_axi_tx_tlast, s_axi_tx_tready, s_axi_tx_tvalid, TX_PE_DATA, TX_PE_DATA_V);
    end

endmodule
