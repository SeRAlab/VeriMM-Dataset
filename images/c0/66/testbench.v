`timescale 1ns/1ps

module jt51_pm_tb;

    // Testbench signals (combinational circuit)
    reg add;
    reg [6:0] kc;
    reg [5:0] kf;
    reg [8:0] mod;
    wire [12:0] kcex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jt51_pm dut (
        .add(add),
        .kc(kc),
        .kf(kf),
        .mod(mod),
        .kcex(kcex)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero addition", test_num);
            kc  = 7'h00;
            kf  = 6'h00;
            mod = 9'h000;
            add = 1'b1;

            #1;


            check_outputs(13'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero subtraction", test_num);
            kc  = 7'h00;
            kf  = 6'h00;
            mod = 9'h000;
            add = 1'b0;

            #1;


            check_outputs(13'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic addition without carry-out of kf", test_num);
            kc  = 7'h10;
            kf  = 6'h05;
            mod = 9'h002;
            add = 1'b1;

            #1;


            check_outputs(13'h0407);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with carry-out from kf into kc", test_num);
            kc  = 7'h10;
            kf  = 6'h3F;
            mod = 9'h001;
            add = 1'b1;

            #1;


            check_outputs(13'h0440);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic subtraction", test_num);
            kc  = 7'h10;
            kf  = 6'h05;
            mod = 9'h006;
            add = 1'b0;

            #1;


            check_outputs(13'h03FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large modulation addition", test_num);
            kc  = 7'h40;
            kf  = 6'h00;
            mod = 9'h1FF;
            add = 1'b1;

            #1;


            check_outputs(13'h11FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large modulation subtraction", test_num);
            kc  = 7'h40;
            kf  = 6'h00;
            mod = 9'h1FF;
            add = 1'b0;

            #1;


            check_outputs(13'h0E01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition overflow (13-bit wrap)", test_num);
            kc  = 7'h7F;
            kf  = 6'h3F;
            mod = 9'h002;
            add = 1'b1;

            #1;


            check_outputs(13'h0001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction underflow (13-bit wrap)", test_num);
            kc  = 7'h00;
            kf  = 6'h00;
            mod = 9'h001;
            add = 1'b0;

            #1;


            check_outputs(13'h1FFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum modulation impact", test_num);
            kc  = 7'h20;
            kf  = 6'h10;
            mod = 9'h1FF;
            add = 1'b1;

            #1;


            check_outputs(13'h0A0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jt51_pm Testbench");
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
        input [12:0] expected_kcex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_kcex === (expected_kcex ^ kcex ^ expected_kcex)) begin
                $display("PASS");
                $display("  Outputs: kcex=%h",
                         kcex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: kcex=%h",
                         expected_kcex);
                $display("  Got:      kcex=%h",
                         kcex);
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
