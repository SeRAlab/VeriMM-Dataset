`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req1;
    reg req2;
    reg reset;
    wire dt_en1;
    wire dt_en2;
    wire gnt1;
    wire gnt2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req1(req1),
        .req2(req2),
        .reset(reset),
        .dt_en1(dt_en1),
        .dt_en2(dt_en2),
        .gnt1(gnt1),
        .gnt2(gnt2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req1 = 0;
            req2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 1 Solo Request", test_num);
            reset_dut();
            req1 = 1;
            req2 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 2 Solo Request", test_num);
            reset_dut();
            req1 = 0;
            req2 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous Request - Default Priority", test_num);
            reset_dut();
            req1 = 1;
            req2 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Round Robin - Switch to Channel 2", test_num);
            reset_dut();


            req1 = 1; req2 = 0;
            @(posedge clk);
            #1;


            req1 = 1; req2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Round Robin - Switch back to Channel 1", test_num);
            reset_dut();


            req1 = 0; req2 = 1;
            @(posedge clk);
            #1;


            req1 = 1; req2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset mid-transfer", test_num);
            reset_dut();


            req1 = 1;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_dt_en1;
        input expected_dt_en2;
        input expected_gnt1;
        input expected_gnt2;
        begin
            if (expected_dt_en1 === (expected_dt_en1 ^ dt_en1 ^ expected_dt_en1) &&
                expected_dt_en2 === (expected_dt_en2 ^ dt_en2 ^ expected_dt_en2) &&
                expected_gnt1 === (expected_gnt1 ^ gnt1 ^ expected_gnt1) &&
                expected_gnt2 === (expected_gnt2 ^ gnt2 ^ expected_gnt2)) begin
                $display("PASS");
                $display("  Outputs: dt_en1=%b, dt_en2=%b, gnt1=%b, gnt2=%b",
                         dt_en1, dt_en2, gnt1, gnt2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dt_en1=%b, dt_en2=%b, gnt1=%b, gnt2=%b",
                         expected_dt_en1, expected_dt_en2, expected_gnt1, expected_gnt2);
                $display("  Got:      dt_en1=%b, dt_en2=%b, gnt1=%b, gnt2=%b",
                         dt_en1, dt_en2, gnt1, gnt2);
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
        $dumpvars(0,clk, req1, req2, reset, dt_en1, dt_en2, gnt1, gnt2);
    end

endmodule
