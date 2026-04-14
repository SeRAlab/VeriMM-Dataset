`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] x;
    wire [3:0] u;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .u(u)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Zero Input State", test_num);
            reset_dut();
            x = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Unit Input State", test_num);
            reset_dut();
            x = 4'b0001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(dut.GAIN_MATRIX_K * 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Maximum Input State", test_num);
            reset_dut();
            x = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(dut.GAIN_MATRIX_K * 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Mid-range Input State", test_num);
            reset_dut();
            x = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(dut.GAIN_MATRIX_K * 4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset Persistence", test_num);
            reset = 1;
            x = 4'h5;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'b0000);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deadbeat_controller Testbench");
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
        input [3:0] expected_u;
        begin
            if (expected_u === (expected_u ^ u ^ expected_u)) begin
                $display("PASS");
                $display("  Outputs: u=%h",
                         u);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: u=%h",
                         expected_u);
                $display("  Got:      u=%h",
                         u);
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
        $dumpvars(0,clk, reset, x, u);
    end

endmodule
