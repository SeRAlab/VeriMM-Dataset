`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg edma_wait;
    reg [7:0] mi_addr;
    reg [63:0] mi_din;
    reg mi_en;
    reg mi_we;
    reg reset;
    wire edma_access;
    wire [103:0] edma_packet;
    wire [31:0] mi_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .edma_wait(edma_wait),
        .mi_addr(mi_addr),
        .mi_din(mi_din),
        .mi_en(mi_en),
        .mi_we(mi_we),
        .reset(reset),
        .edma_access(edma_access),
        .edma_packet(edma_packet),
        .mi_dout(mi_dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Executing Testcase %0d: Reset and Default State Check", test_num);


            reset = 1;
            mi_en = 0;
            mi_we = 0;
            mi_addr = 8'h00;
            mi_din = 64'h0;
            edma_wait = 0;

            repeat(2) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 104'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Executing Testcase %0d: Write Attempt Check", test_num);

            reset = 1; #10; reset = 0;
            @(posedge clk);


            mi_en = 1'b1;
            mi_we = 1'b1;
            mi_addr = 8'hAA;
            mi_din = 64'hFEDCBA9876543210;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 104'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Executing Testcase %0d: Read Attempt Check", test_num);

            reset = 1; #10; reset = 0;
            @(posedge clk);


            mi_en = 1'b1;
            mi_we = 1'b0;
            mi_addr = 8'h55;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 104'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Executing Testcase %0d: EDMA Wait Signal Check", test_num);

            reset = 1; #10; reset = 0;
            @(posedge clk);


            edma_wait = 1'b1;
            mi_en = 1'b1;
            mi_addr = 8'hFF;

            repeat(3) @(posedge clk);


            #1;



            check_outputs(1'b0, 104'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Executing Testcase %0d: Boundary Address and Data Check", test_num);

            reset = 1; #10; reset = 0;
            @(posedge clk);


            mi_en = 1'b1;
            mi_we = 1'b1;
            mi_addr = 8'hFF;
            mi_din = 64'hFFFFFFFFFFFFFFFF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 104'h0, 32'h0);


            mi_en = 1'b1;
            mi_we = 1'b1;
            mi_addr = 8'h00;
            mi_din = 64'h0000000000000000;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 104'h0, 32'h0);
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
        input expected_edma_access;
        input [103:0] expected_edma_packet;
        input [31:0] expected_mi_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edma_access === (expected_edma_access ^ edma_access ^ expected_edma_access) &&
                expected_edma_packet === (expected_edma_packet ^ edma_packet ^ expected_edma_packet) &&
                expected_mi_dout === (expected_mi_dout ^ mi_dout ^ expected_mi_dout)) begin
                $display("PASS");
                $display("  Outputs: edma_access=%b, edma_packet=%h, mi_dout=%h",
                         edma_access, edma_packet, mi_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edma_access=%b, edma_packet=%h, mi_dout=%h",
                         expected_edma_access, expected_edma_packet, expected_mi_dout);
                $display("  Got:      edma_access=%b, edma_packet=%h, mi_dout=%h",
                         edma_access, edma_packet, mi_dout);
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
