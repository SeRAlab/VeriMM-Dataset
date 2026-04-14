`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg fclk;
    reg rdat_n;
    wire vg_rawr;
    wire vg_rclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fclk(fclk),
        .rdat_n(rdat_n),
        .vg_rawr(vg_rawr),
        .vg_rclk(vg_rclk)
    );

    // Clock generation (10ns period)
    initial begin
        fclk = 0;
        forever #5 fclk = ~fclk;
    end

        task reset_dut;

    begin
        rdat_n = 1;
        #20;
        $display("Status: DUT Reset Applied (rdat_n = 1)");
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Idle State Check", test_num);
        reset_dut();


        repeat(5) @(posedge fclk);
        #2;




        #1;





        check_outputs(1, vg_rclk);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Active Signal (rdat_n = 0)", test_num);
        reset_dut();

        @(posedge fclk);
        rdat_n = 0;


        repeat(5) @(posedge fclk);
        #2;


        #1;



        check_outputs(0, vg_rclk);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Signal Recovery Check", test_num);
        reset_dut();


        @(posedge fclk);
        rdat_n = 0;
        repeat(2) @(posedge fclk);


        rdat_n = 1;
        repeat(5) @(posedge fclk);
        #2;


        #1;



        check_outputs(1, vg_rclk);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Short Pulse Stimulus", test_num);
        reset_dut();

        @(posedge fclk);
        rdat_n = 0;
        @(posedge fclk);
        rdat_n = 1;


        repeat(10) @(posedge fclk);
        #2;


        #1;



        check_outputs(1, vg_rclk);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Extended Operation/Clock Observation", test_num);
        reset_dut();

        rdat_n = 0;


        repeat(50) @(posedge fclk);
        #2;


        #1;



        check_outputs(0, vg_rclk);
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
        input expected_vg_rawr;
        input expected_vg_rclk;
        begin
            if (expected_vg_rawr === (expected_vg_rawr ^ vg_rawr ^ expected_vg_rawr) &&
                expected_vg_rclk === (expected_vg_rclk ^ vg_rclk ^ expected_vg_rclk)) begin
                $display("PASS");
                $display("  Outputs: vg_rawr=%b, vg_rclk=%b",
                         vg_rawr, vg_rclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vg_rawr=%b, vg_rclk=%b",
                         expected_vg_rawr, expected_vg_rclk);
                $display("  Got:      vg_rawr=%b, vg_rclk=%b",
                         vg_rawr, vg_rclk);
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
        $dumpvars(0,fclk, rdat_n, vg_rawr, vg_rclk);
    end

endmodule
