`timescale 1ns/1ps

module monte_carlo_lfsr_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] seed;
    wire [4:0] random_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_lfsr dut (
        .seed(seed),
        .random_number(random_number)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Seed = 5'h01", test_num);
        seed = 5'h01;

        #1;


        check_outputs(5'h02);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Seed = 5'h02", test_num);
        seed = 5'h02;

        #1;


        check_outputs(5'h04);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Seed = 5'h04", test_num);
        seed = 5'h04;

        #1;


        check_outputs(5'h09);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Seed = 5'h08", test_num);
        seed = 5'h08;

        #1;


        check_outputs(5'h10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Seed = 5'h10", test_num);
        seed = 5'h10;

        #1;


        check_outputs(5'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Seed = 5'h1F (All ones)", test_num);
        seed = 5'h1F;

        #1;


        check_outputs(5'h1E);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Seed = 5'h00 (Zero check)", test_num);
        seed = 5'h00;

        #1;


        check_outputs(5'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Seed = 5'h0A", test_num);
        seed = 5'h0A;

        #1;


        check_outputs(5'h14);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_lfsr Testbench");
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
        input [4:0] expected_random_number;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_random_number === (expected_random_number ^ random_number ^ expected_random_number)) begin
                $display("PASS");
                $display("  Outputs: random_number=%h",
                         random_number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_number=%h",
                         expected_random_number);
                $display("  Got:      random_number=%h",
                         random_number);
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
