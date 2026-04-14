`timescale 1ns/1ps

module up_down_counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg up_down;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_3bit dut (
        .clk(clk),
        .rst(rst),
        .up_down(up_down),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            up_down = 1;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Count up once", test_num);
            reset_dut();
            up_down = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Count up wrap around", test_num);
            reset_dut();
            up_down = 1;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Count down once (wrap around)", test_num);
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Count down multiple", test_num);
            reset_dut();
            up_down = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Change direction mid-count", test_num);
            reset_dut();
            up_down = 1;
            repeat(4) @(posedge clk);
            up_down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Synchronous reset during operation", test_num);
            reset_dut();
            up_down = 1;
            repeat(5) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Complex sequence up and down", test_num);
            reset_dut();
            up_down = 1;
            repeat(2) @(posedge clk);
            up_down = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_3bit Testbench");
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
        input [2:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, rst, up_down, Q);
    end

endmodule
