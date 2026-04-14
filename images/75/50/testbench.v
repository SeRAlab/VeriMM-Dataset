`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [31:0] def;
    reg [7:0] phase;
    wire [7:0] adr;
    wire clk2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .def(def),
        .phase(phase),
        .adr(adr),
        .clk2(clk2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            def = 0;
            phase = 0;
            #15;
            clr = 0;
            #5;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            def = 32'h0000_0001;
            phase = 8'h00;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            def = 32'h8000_0000;
            phase = 8'h00;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h80, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            def = 0;
            phase = 8'hAA;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            def = 32'h0100_0000;
            phase = 8'h05;
            repeat(3) @(posedge clk);
            #1;



            #1;




            check_outputs(8'h08, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            def = 32'hF000_0000;
            phase = 8'h20;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h10, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            def = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            clr = 1;
            #2;
            #1;

            check_outputs(8'h00, 1'b0);
            clr = 0;
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
        input [7:0] expected_adr;
        input expected_clk2;
        begin
            if (expected_adr === (expected_adr ^ adr ^ expected_adr) &&
                expected_clk2 === (expected_clk2 ^ clk2 ^ expected_clk2)) begin
                $display("PASS");
                $display("  Outputs: adr=%h, clk2=%b",
                         adr, clk2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adr=%h, clk2=%b",
                         expected_adr, expected_clk2);
                $display("  Got:      adr=%h, clk2=%b",
                         adr, clk2);
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
        $dumpvars(0,clk, clr, def, phase, adr, clk2);
    end

endmodule
