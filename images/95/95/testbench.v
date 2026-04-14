`timescale 1ns/1ps

module elevator_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg down;
    reg up;
    wire [1:0] floor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    elevator dut (
        .areset(areset),
        .clk(clk),
        .down(down),
        .up(up),
        .floor(floor)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            up = 0;
            down = 0;
            #12;
            areset = 0;
            #5;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset to Floor 1", test_num);
            reset_dut();
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Moving Floor 1 -> Floor 2", test_num);
            reset_dut();
            up = 1; down = 0;
            @(posedge clk);
            #1;
            up = 0;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Moving Floor 1 -> Floor 3", test_num);
            reset_dut();
            up = 1; down = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            up = 0;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Boundary Check - Down from Floor 1", test_num);
            reset_dut();
            up = 0; down = 1;
            @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary Check - Up from Floor 3", test_num);
            reset_dut();
            up = 1; down = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            up = 0;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Move Up then Down (F1 -> F2 -> F1)", test_num);
            reset_dut();
            up = 1; down = 0;
            @(posedge clk);
            up = 0; down = 1;
            @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Idle Check - Both signals 1 at Floor 2", test_num);
            reset_dut();
            up = 1; down = 0;
            @(posedge clk);
            up = 1; down = 1;
            @(posedge clk);
            #1;
            up = 0; down = 0;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Idle Check - Both signals 0 at Floor 2", test_num);
            reset_dut();
            up = 1; down = 0;
            @(posedge clk);
            up = 0; down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Moving Floor 3 -> Floor 2", test_num);
            reset_dut();
            up = 1; down = 0;
            @(posedge clk);
            @(posedge clk);
            up = 0; down = 1;
            @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Full Cycle (F1 -> F2 -> F3 -> F2 -> F1)", test_num);
            reset_dut();
            up = 1; @(posedge clk);
            up = 1; @(posedge clk);
            up = 0; down = 1; @(posedge clk);
            down = 1; @(posedge clk);
            #1;
            down = 0;
            #1;

            check_outputs(2'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("elevator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_floor;
        begin
            if (expected_floor === (expected_floor ^ floor ^ expected_floor)) begin
                $display("PASS");
                $display("  Outputs: floor=%h",
                         floor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: floor=%h",
                         expected_floor);
                $display("  Got:      floor=%h",
                         floor);
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
        $dumpvars(0,areset, clk, down, up, floor);
    end

endmodule
