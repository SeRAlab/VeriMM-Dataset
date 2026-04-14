`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg global_enable;
    reg [3:0] interrupt_req;
    reg reset;
    wire [3:0] interrupt_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clear(clear),
        .clk(clk),
        .global_enable(global_enable),
        .interrupt_req(interrupt_req),
        .reset(reset),
        .interrupt_flag(interrupt_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            global_enable = 0;
            interrupt_req = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Interrupt Bit 0 (Highest Priority)", test_num);
            reset_dut();
            global_enable = 1;
            interrupt_req = 4'b0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Global Enable OFF", test_num);
            reset_dut();
            global_enable = 0;
            interrupt_req = 4'b1111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Test (Bit 0 vs Bit 3)", test_num);
            reset_dut();
            global_enable = 1;
            interrupt_req = 4'b1001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Test (Bit 1 vs Bit 2 vs Bit 3)", test_num);
            reset_dut();
            global_enable = 1;
            interrupt_req = 4'b1110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Clear Signal Functionality", test_num);
            reset_dut();
            global_enable = 1;
            interrupt_req = 4'b0100;
            @(posedge clk);
            #2;
            clear = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Interrupt Bit 3 (Lowest Priority)", test_num);
            reset_dut();
            global_enable = 1;
            interrupt_req = 4'b1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority shift after clear", test_num);
            reset_dut();
            global_enable = 1;
            interrupt_req = 4'b0011;
            @(posedge clk);
            #1;

            clear = 1;
            interrupt_req = 4'b0010;
            @(posedge clk);
            #1;
            clear = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("interrupt_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_interrupt_flag;
        begin
            if (expected_interrupt_flag === (expected_interrupt_flag ^ interrupt_flag ^ expected_interrupt_flag)) begin
                $display("PASS");
                $display("  Outputs: interrupt_flag=%h",
                         interrupt_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt_flag=%h",
                         expected_interrupt_flag);
                $display("  Got:      interrupt_flag=%h",
                         interrupt_flag);
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
        $dumpvars(0,clear, clk, global_enable, interrupt_req, reset, interrupt_flag);
    end

endmodule
