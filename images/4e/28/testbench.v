`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg [3:0] irq;
    wire [7:0] vec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack(ack),
        .irq(irq),
        .vec(vec)
    );

    // Clock generation (10ns period)
    initial begin
        ack = 0;
        forever #5 ack = ~ack;
    end

        task reset_dut;

        begin
            irq = 4'b0000;
            @(negedge ack);
            @(negedge ack);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            irq = 4'b0000;
            @(posedge ack);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            irq = 4'b0001;
            @(posedge ack);
            #2;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            irq = 4'b1000;
            @(posedge ack);
            #2;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            irq = 4'b0110;
            @(posedge ack);
            #2;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            irq = 4'b1111;
            @(posedge ack);
            #2;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            irq = 4'b0100;
            @(posedge ack);
            #2;

            @(posedge ack);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            irq = 4'b1001;
            @(posedge ack);
            #2;
            @(posedge ack);
            #2;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            irq = 4'b0010;
            @(posedge ack);
            #2;
            irq = 4'b0000;
            @(negedge ack);
            irq = 4'b0010;
            @(posedge ack);
            #2;
            #1;

            check_outputs(8'h02);
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
        input [7:0] expected_vec;
        begin
            if (expected_vec === (expected_vec ^ vec ^ expected_vec)) begin
                $display("PASS");
                $display("  Outputs: vec=%h",
                         vec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vec=%h",
                         expected_vec);
                $display("  Got:      vec=%h",
                         vec);
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
        $dumpvars(0,ack, irq, vec);
    end

endmodule
