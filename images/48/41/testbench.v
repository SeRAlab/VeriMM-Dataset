`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] paddr;
    reg pclk;
    reg penable;
    reg [2:0] pprot;
    reg presetn;
    reg psel;
    reg [31:0] pwdata;
    reg pwrite;
    wire intr;
    wire [31:0] prdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .paddr(paddr),
        .pclk(pclk),
        .penable(penable),
        .pprot(pprot),
        .presetn(presetn),
        .psel(psel),
        .pwdata(pwdata),
        .pwrite(pwrite),
        .intr(intr),
        .prdata(prdata)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset", test_num);

            pclk = 0;
            presetn = 0;
            psel = 0;
            penable = 0;
            paddr = 0;
            pwrite = 0;
            pwdata = 0;
            pprot = 0;

            repeat(2) @(posedge pclk);
            presetn = 1;
            @(posedge pclk);


            #1;



            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write Operation", test_num);


            presetn = 0;
            @(posedge pclk);
            presetn = 1;


            @(posedge pclk);
            psel = 1;
            pwrite = 1;
            paddr = 32'hDEADBEEF;
            pwdata = 32'h12345678;
            penable = 0;


            @(posedge pclk);
            penable = 1;

            @(posedge pclk);

            psel = 0;
            penable = 0;

            #1;


            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Read Operation", test_num);


            presetn = 0;
            @(posedge pclk);
            presetn = 1;


            @(posedge pclk);
            psel = 1;
            pwrite = 0;
            paddr = 32'hCAFEBABE;
            penable = 0;


            @(posedge pclk);
            penable = 1;

            @(posedge pclk);
            psel = 0;
            penable = 0;

            #1;


            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address and Protection Bit Robustness", test_num);


            presetn = 0;
            @(posedge pclk);
            presetn = 1;


            @(posedge pclk);
            psel = 1;
            pwrite = 0;
            paddr = 32'h00001234;
            pprot = 3'b110;
            penable = 0;


            @(posedge pclk);
            penable = 1;

            @(posedge pclk);
            psel = 0;
            penable = 0;

            #1;


            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Transfers", test_num);


            presetn = 0;
            @(posedge pclk);
            presetn = 1;


            @(posedge pclk);
            psel = 1; pwrite = 1; paddr = 32'hA; penable = 0;
            @(posedge pclk);
            penable = 1;
            @(posedge pclk);


            psel = 1; pwrite = 0; paddr = 32'hB; penable = 0;
            @(posedge pclk);
            penable = 1;
            @(posedge pclk);

            psel = 0;
            penable = 0;

            #1;


            check_outputs(1'b0, 32'h00000000);
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
        input expected_intr;
        input [31:0] expected_prdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_intr === (expected_intr ^ intr ^ expected_intr) &&
                expected_prdata === (expected_prdata ^ prdata ^ expected_prdata)) begin
                $display("PASS");
                $display("  Outputs: intr=%b, prdata=%h",
                         intr, prdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: intr=%b, prdata=%h",
                         expected_intr, expected_prdata);
                $display("  Got:      intr=%b, prdata=%h",
                         intr, prdata);
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
