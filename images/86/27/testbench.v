`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] paddr;
    reg pclk;
    reg penable;
    reg psel;
    reg [7:0] pwdata;
    reg pwrite;
    wire [7:0] prdata;
    wire pready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .paddr(paddr),
        .pclk(pclk),
        .penable(penable),
        .psel(psel),
        .pwdata(pwdata),
        .pwrite(pwrite),
        .prdata(prdata),
        .pready(pready)
    );

    // Clock generation (10ns period)
    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

        task reset_dut;

        begin
            @(posedge pclk);
            psel = 0;
            penable = 0;
            paddr = 0;
            pwdata = 0;
            pwrite = 0;
            @(posedge pclk);
        end
        endtask
    task apb_write;

        input [7:0] addr;
        input [7:0] data;
        begin
            @(posedge pclk);
            psel = 1;
            pwrite = 1;
            paddr = addr;
            pwdata = data;
            penable = 0;
            @(posedge pclk);
            penable = 1;
            @(posedge pclk);
            psel = 0;
            penable = 0;
        end
        endtask

    task apb_read;

        input [7:0] addr;
        begin
            @(posedge pclk);
            psel = 1;
            pwrite = 0;
            paddr = addr;
            penable = 0;
            @(posedge pclk);
            penable = 1;
            @(posedge pclk);

        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            apb_write(8'h00, 8'hA5);
            apb_read(8'h00);
            #1;

            check_outputs(8'hA5, 1'b1);
            psel = 0; penable = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            apb_write(8'h07, 8'h5A);
            apb_read(8'h07);
            #1;

            check_outputs(8'h5A, 1'b1);
            psel = 0; penable = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            apb_write(8'h03, 8'h11);
            apb_write(8'h03, 8'h22);
            apb_read(8'h03);
            #1;

            check_outputs(8'h22, 1'b1);
            psel = 0; penable = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge pclk);
            psel = 1;
            #1;
            #1;

            check_outputs(prdata, 1'b1);
            psel = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge pclk);
            psel = 1;
            pwrite = 1;
            paddr = 8'h04;
            pwdata = 8'h99;
            penable = 0;
            @(posedge pclk);
            psel = 0;


            apb_read(8'h04);
            if (prdata !== 8'h99) begin
                $display("Test 005 logic passed: Data not written without penable.");
                pass_count = pass_count + 1;
            end else begin
                $display("Test 005 logic failed: Data written even without penable!");
                fail_count = fail_count + 1;
            end
            psel = 0; penable = 0;
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
        input [7:0] expected_prdata;
        input expected_pready;
        begin
            if (expected_prdata === (expected_prdata ^ prdata ^ expected_prdata) &&
                expected_pready === (expected_pready ^ pready ^ expected_pready)) begin
                $display("PASS");
                $display("  Outputs: prdata=%h, pready=%b",
                         prdata, pready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prdata=%h, pready=%b",
                         expected_prdata, expected_pready);
                $display("  Got:      prdata=%h, pready=%b",
                         prdata, pready);
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
        $dumpvars(0,paddr, pclk, penable, psel, pwdata, pwrite, prdata, pready);
    end

endmodule
