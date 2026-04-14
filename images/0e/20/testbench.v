`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg high_priority_req;
    reg low_priority_req;
    reg reset;
    wire high_priority_serviced;
    wire low_priority_serviced;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .high_priority_req(high_priority_req),
        .low_priority_req(low_priority_req),
        .reset(reset),
        .high_priority_serviced(high_priority_serviced),
        .low_priority_serviced(low_priority_serviced)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            high_priority_req = 0;
            low_priority_req = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking Idle State", test_num);
            reset_dut();

            high_priority_req = 0;
            low_priority_req = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Priority Request Only", test_num);
            reset_dut();
            high_priority_req = 1;
            low_priority_req = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low Priority Request Only", test_num);
            reset_dut();
            high_priority_req = 0;
            low_priority_req = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Requests (High Priority wins)", test_num);
            reset_dut();
            high_priority_req = 1;
            low_priority_req = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from Low to High Priority", test_num);
            reset_dut();

            low_priority_req = 1;
            @(posedge clk);

            high_priority_req = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Removing All Requests", test_num);
            reset_dut();
            high_priority_req = 1;
            @(posedge clk);
            high_priority_req = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fallback to Low Priority", test_num);
            reset_dut();
            high_priority_req = 1;
            low_priority_req = 1;
            @(posedge clk);
            high_priority_req = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during active service", test_num);
            reset_dut();
            high_priority_req = 1;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0);
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
        input expected_high_priority_serviced;
        input expected_low_priority_serviced;
        begin
            if (expected_high_priority_serviced === (expected_high_priority_serviced ^ high_priority_serviced ^ expected_high_priority_serviced) &&
                expected_low_priority_serviced === (expected_low_priority_serviced ^ low_priority_serviced ^ expected_low_priority_serviced)) begin
                $display("PASS");
                $display("  Outputs: high_priority_serviced=%b, low_priority_serviced=%b",
                         high_priority_serviced, low_priority_serviced);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high_priority_serviced=%b, low_priority_serviced=%b",
                         expected_high_priority_serviced, expected_low_priority_serviced);
                $display("  Got:      high_priority_serviced=%b, low_priority_serviced=%b",
                         high_priority_serviced, low_priority_serviced);
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
        $dumpvars(0,clk, high_priority_req, low_priority_req, reset, high_priority_serviced, low_priority_serviced);
    end

endmodule
