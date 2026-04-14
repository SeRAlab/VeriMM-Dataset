`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] int_req;
    reg rst;
    wire int_pending;
    wire [3:0] int_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .int_req(int_req),
        .rst(rst),
        .int_pending(int_pending),
        .int_status(int_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            int_req = 4'b0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single interrupt bit 0", test_num);
            reset_dut();
            int_req = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple simultaneous interrupts", test_num);
            reset_dut();
            int_req = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interrupt status persistence", test_num);
            reset_dut();
            int_req = 4'b0100;
            @(posedge clk);
            #1 int_req = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cumulative interrupts", test_num);
            reset_dut();
            int_req = 4'b0001;
            @(posedge clk);
            #1 int_req = 4'b0010;
            @(posedge clk);
            #1 int_req = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All interrupt bits set", test_num);
            reset_dut();
            int_req = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interrupt request during reset", test_num);
            rst = 1;
            int_req = 4'b1111;
            @(posedge clk);
            #1 rst = 0;

            #1;


            check_outputs(1'b0, 4'b0000);
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
        input expected_int_pending;
        input [3:0] expected_int_status;
        begin
            if (expected_int_pending === (expected_int_pending ^ int_pending ^ expected_int_pending) &&
                expected_int_status === (expected_int_status ^ int_status ^ expected_int_status)) begin
                $display("PASS");
                $display("  Outputs: int_pending=%b, int_status=%h",
                         int_pending, int_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_pending=%b, int_status=%h",
                         expected_int_pending, expected_int_status);
                $display("  Got:      int_pending=%b, int_status=%h",
                         int_pending, int_status);
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
        $dumpvars(0,clk, int_req, rst, int_pending, int_status);
    end

endmodule
