`timescale 1ns/1ps

module new_module_13_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg g;
    wire h;
    wire j;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module_13 dut (
        .clock(clock),
        .g(g),
        .h(h),
        .j(j)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            g = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Replicating waveform sequence");
            reset_dut();


            g = 1;
            @(posedge clock);
            #2;


            g = 1;
            @(posedge clock);
            #2;


            g = 1;
            @(posedge clock);
            #2;


            g = 1;
            @(posedge clock);
            #2;


            g = 1;
            @(posedge clock);
            #2;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Testing state toggle (1,0) <-> (0,1)");
            reset_dut();

            g = 1;

            repeat(4) @(posedge clock);
            #2;


            if (h === 1'b1 && j === 1'b0) begin

                @(posedge clock);
                #2;

                #1;


                check_outputs(1'b0, 1'b1);
            end else begin
                $display("FAILED: Expected start state (1,0) not reached.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Testing g input inhibit");
            reset_dut();

            g = 1;
            @(posedge clock);
            #2;

            g = 0;
            @(posedge clock);
            #2;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("new_module_13 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input expected_h;
        input expected_j;
        begin
            if (expected_h === (expected_h ^ h ^ expected_h) &&
                expected_j === (expected_j ^ j ^ expected_j)) begin
                $display("PASS");
                $display("  Outputs: h=%b, j=%b",
                         h, j);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%b, j=%b",
                         expected_h, expected_j);
                $display("  Got:      h=%b, j=%b",
                         h, j);
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
        $dumpvars(0,clock, g, h, j);
    end

endmodule
