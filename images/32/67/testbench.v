`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg clk;
    wire phase_high;
    wire phase_low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .A(A),
        .B(B),
        .clk(clk),
        .phase_high(phase_high),
        .phase_low(phase_low)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signal A leads Signal B", test_num);
            reset_dut();

            A = 1;
            repeat(2) @(posedge clk);
            B = 1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signal B leads Signal A", test_num);
            reset_dut();

            B = 1;
            repeat(2) @(posedge clk);
            A = 1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Extended lead for Signal A", test_num);
            reset_dut();

            A = 1;
            repeat(5) @(posedge clk);
            B = 1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signal A transitions, B remains low", test_num);
            reset_dut();

            A = 1;
            repeat(4) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signal B transitions, A remains low", test_num);
            reset_dut();

            B = 1;
            repeat(4) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous rising edges (In-phase)", test_num);
            reset_dut();

            A = 1;
            B = 1;
            repeat(3) @(posedge clk);



            #1;




            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stability check after signals return to low", test_num);
            reset_dut();


            A = 1;
            repeat(1) @(posedge clk);
            B = 1;
            repeat(2) @(posedge clk);



            A = 0;
            B = 0;
            repeat(2) @(posedge clk);




            #1;





            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_detector Testbench");
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
        input expected_phase_high;
        input expected_phase_low;
        begin
            if (expected_phase_high === (expected_phase_high ^ phase_high ^ expected_phase_high) &&
                expected_phase_low === (expected_phase_low ^ phase_low ^ expected_phase_low)) begin
                $display("PASS");
                $display("  Outputs: phase_high=%b, phase_low=%b",
                         phase_high, phase_low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_high=%b, phase_low=%b",
                         expected_phase_high, expected_phase_low);
                $display("  Got:      phase_high=%b, phase_low=%b",
                         phase_high, phase_low);
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
        $dumpvars(0,A, B, clk, phase_high, phase_low);
    end

endmodule
