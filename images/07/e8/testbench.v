`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dist;
    wire [15:0] updated_dist;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .dist(dist),
        .updated_dist(updated_dist)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Empty Graph");
        dist = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Self-loops Only (Identity Matrix)");
        dist = 16'h8421;
        #1;

        check_outputs(16'h8421);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Linear Chain 0->1->2->3");

        dist = 16'h4210;


        #1;



        check_outputs(16'h7310);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Complete Graph (All Ones)");
        dist = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Full Cycle 0->1->2->3->0");

        dist = 16'h4218;

        #1;


        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Star Graph Center 0 (0->1, 0->2, 0->3)");

        dist = 16'h7000;

        #1;


        check_outputs(16'h7000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Reverse Linear Chain 3->2->1->0");

        dist = 16'h0842;





        #1;






        check_outputs(16'h08CE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Disconnected Cycles (0-1) and (2-3)");


        dist = 16'h4812;



        #1;




        check_outputs(16'hCC33);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("floyd_warshall Testbench");
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
        input [15:0] expected_updated_dist;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_updated_dist === (expected_updated_dist ^ updated_dist ^ expected_updated_dist)) begin
                $display("PASS");
                $display("  Outputs: updated_dist=%h",
                         updated_dist);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_dist=%h",
                         expected_updated_dist);
                $display("  Got:      updated_dist=%h",
                         updated_dist);
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

endmodule
