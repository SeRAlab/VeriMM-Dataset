`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] haddr;
    reg hclk;
    reg [3:0] hprot;
    reg hrst_b;
    reg hsel;
    reg [2:0] hsize;
    reg [1:0] htrans;
    reg [31:0] hwdata;
    reg hwrite;
    wire [31:0] hrdata;
    wire hready;
    wire [1:0] hresp;
    wire intr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .haddr(haddr),
        .hclk(hclk),
        .hprot(hprot),
        .hrst_b(hrst_b),
        .hsel(hsel),
        .hsize(hsize),
        .htrans(htrans),
        .hwdata(hwdata),
        .hwrite(hwrite),
        .hrdata(hrdata),
        .hready(hready),
        .hresp(hresp),
        .intr(intr)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b1, 2'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Read Transaction", test_num);
            reset_dut();

            @(posedge hclk);
            hsel   = 1;
            haddr  = 32'h12345678;
            hwrite = 0;
            htrans = 2'b10;
            hsize  = 3'b010;

            @(posedge hclk);

            #1;


            check_outputs(32'h0, 1'b1, 2'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Write Transaction", test_num);
            reset_dut();

            @(posedge hclk);
            hsel   = 1;
            haddr  = 32'hDEADBEEF;
            hwrite = 1;
            htrans = 2'b10;
            hwdata = 32'hCAFEBABE;

            @(posedge hclk);

            #1;


            check_outputs(32'h0, 1'b1, 2'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Module Not Selected", test_num);
            reset_dut();

            @(posedge hclk);
            hsel   = 0;
            haddr  = 32'h00001111;
            htrans = 2'b10;

            @(posedge hclk);

            #1;


            check_outputs(32'h0, 1'b1, 2'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Varying Size and Prot", test_num);
            reset_dut();

            @(posedge hclk);
            hsel   = 1;
            haddr  = 32'h88884444;
            hsize  = 3'b000;
            hprot  = 4'b1111;
            hwrite = 0;

            @(posedge hclk);

            #1;


            check_outputs(32'h0, 1'b1, 2'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle Transactions", test_num);
            reset_dut();

            @(posedge hclk);
            hsel   = 1;
            htrans = 2'b00;

            @(posedge hclk);
            #1;

            check_outputs(32'h0, 1'b1, 2'b0, 1'b0);
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
        testcase006();
        
        
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
        input [31:0] expected_hrdata;
        input expected_hready;
        input [1:0] expected_hresp;
        input expected_intr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hrdata === (expected_hrdata ^ hrdata ^ expected_hrdata) &&
                expected_hready === (expected_hready ^ hready ^ expected_hready) &&
                expected_hresp === (expected_hresp ^ hresp ^ expected_hresp) &&
                expected_intr === (expected_intr ^ intr ^ expected_intr)) begin
                $display("PASS");
                $display("  Outputs: hrdata=%h, hready=%b, hresp=%h, intr=%b",
                         hrdata, hready, hresp, intr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hrdata=%h, hready=%b, hresp=%h, intr=%b",
                         expected_hrdata, expected_hready, expected_hresp, expected_intr);
                $display("  Got:      hrdata=%h, hready=%b, hresp=%h, intr=%b",
                         hrdata, hready, hresp, intr);
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
