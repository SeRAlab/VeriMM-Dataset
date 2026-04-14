`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg hclk;
    reg hrst_b;
    reg mhgrant;
    reg [31:0] mhrdata;
    reg mhready;
    reg [1:0] mhresp;
    wire [31:0] mhaddr;
    wire [2:0] mhburst;
    wire [3:0] mhprot;
    wire [2:0] mhsize;
    wire [1:0] mhtrans;
    wire [31:0] mhwdata;
    wire mhwrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hclk(hclk),
        .hrst_b(hrst_b),
        .mhgrant(mhgrant),
        .mhrdata(mhrdata),
        .mhready(mhready),
        .mhresp(mhresp),
        .mhaddr(mhaddr),
        .mhburst(mhburst),
        .mhprot(mhprot),
        .mhsize(mhsize),
        .mhtrans(mhtrans),
        .mhwdata(mhwdata),
        .mhwrite(mhwrite)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System Reset Performance", test_num);


            hrst_b = 1'b0;
            mhgrant = 1'b0;
            mhrdata = 32'h0;
            mhready = 1'b0;
            mhresp = 2'b0;

            #20;
            hrst_b = 1'b1;
            #10;


            #1;



            check_outputs(32'h0, 3'h0, 4'h0, 3'h0, 2'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Active Bus Grant Scenario", test_num);


            hrst_b = 1'b0;
            #10;
            hrst_b = 1'b1;


            @(posedge hclk);
            mhgrant = 1'b1;
            mhready = 1'b1;
            mhrdata = 32'hCAFE_BABE;
            mhresp  = 2'b00;

            @(posedge hclk);
            #2;

            #1;


            check_outputs(32'h0, 3'h0, 4'h0, 3'h0, 2'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Slave Wait States and Error Responses", test_num);

            hrst_b = 1'b0;
            #10;
            hrst_b = 1'b1;


            @(posedge hclk);
            mhgrant = 1'b1;
            mhready = 1'b0;
            mhresp  = 2'b01;
            mhrdata = 32'hDEAD_BEEF;

            repeat(3) @(posedge hclk);
            #2;

            #1;


            check_outputs(32'h0, 3'h0, 4'h0, 3'h0, 2'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Frequency Input Switching", test_num);

            hrst_b = 1'b0;
            #10;
            hrst_b = 1'b1;


            mhrdata = 32'hFFFF_FFFF;
            mhgrant = 1'b1;
            #2;
            mhrdata = 32'h0000_0000;
            mhgrant = 1'b0;
            #2;
            mhresp = 2'b11;
            mhready = 1'b1;
            #5;

            #1;


            check_outputs(32'h0, 3'h0, 4'h0, 3'h0, 2'h0, 32'h0, 1'b0);
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
        input [31:0] expected_mhaddr;
        input [2:0] expected_mhburst;
        input [3:0] expected_mhprot;
        input [2:0] expected_mhsize;
        input [1:0] expected_mhtrans;
        input [31:0] expected_mhwdata;
        input expected_mhwrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mhaddr === (expected_mhaddr ^ mhaddr ^ expected_mhaddr) &&
                expected_mhburst === (expected_mhburst ^ mhburst ^ expected_mhburst) &&
                expected_mhprot === (expected_mhprot ^ mhprot ^ expected_mhprot) &&
                expected_mhsize === (expected_mhsize ^ mhsize ^ expected_mhsize) &&
                expected_mhtrans === (expected_mhtrans ^ mhtrans ^ expected_mhtrans) &&
                expected_mhwdata === (expected_mhwdata ^ mhwdata ^ expected_mhwdata) &&
                expected_mhwrite === (expected_mhwrite ^ mhwrite ^ expected_mhwrite)) begin
                $display("PASS");
                $display("  Outputs: mhaddr=%h, mhburst=%h, mhprot=%h, mhsize=%h, mhtrans=%h, mhwdata=%h, mhwrite=%b",
                         mhaddr, mhburst, mhprot, mhsize, mhtrans, mhwdata, mhwrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mhaddr=%h, mhburst=%h, mhprot=%h, mhsize=%h, mhtrans=%h, mhwdata=%h, mhwrite=%b",
                         expected_mhaddr, expected_mhburst, expected_mhprot, expected_mhsize, expected_mhtrans, expected_mhwdata, expected_mhwrite);
                $display("  Got:      mhaddr=%h, mhburst=%h, mhprot=%h, mhsize=%h, mhtrans=%h, mhwdata=%h, mhwrite=%b",
                         mhaddr, mhburst, mhprot, mhsize, mhtrans, mhwdata, mhwrite);
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

endmodule
