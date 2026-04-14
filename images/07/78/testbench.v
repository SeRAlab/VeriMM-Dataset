`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg [3:0] REQ;
    reg clk;
    reg reset;
    wire [3:0] GNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .EN(EN),
        .REQ(REQ),
        .clk(clk),
        .reset(reset),
        .GNT(GNT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            EN = 0;
            REQ = 4'b0000;
            reset = 1;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            EN = 1;
            REQ = 4'b0001;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            EN = 1;
            REQ = 4'b1000;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            EN = 0;
            REQ = 4'b1111;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            EN = 1;
            REQ = 4'b1111;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            EN = 1;
            REQ = 4'b1111;
            repeat(4) @(posedge clk);
            #1;
            @(posedge clk);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            EN = 1;
            REQ = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            EN = 1;
            REQ = 4'b0001;
            @(posedge clk);
            #1 REQ = 4'b1000;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_GNT;
        begin
            if (expected_GNT === (expected_GNT ^ GNT ^ expected_GNT)) begin
                $display("PASS");
                $display("  Outputs: GNT=%h",
                         GNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GNT=%h",
                         expected_GNT);
                $display("  Got:      GNT=%h",
                         GNT);
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
        $dumpvars(0,EN, REQ, clk, reset, GNT);
    end

endmodule
