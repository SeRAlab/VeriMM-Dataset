`timescale 1ns/1ps

module qam_mapper_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_data;
    wire [7:0] qam_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_mapper dut (
        .in_data(in_data),
        .qam_out(qam_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0000 (I=-3, Q=-3)", test_num);
            in_data = 4'b0000;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0001 (I=-3, Q=-1)", test_num);
            in_data = 4'b0001;
            #1;

            check_outputs(8'hDF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0010 (I=-3, Q=+1)", test_num);
            in_data = 4'b0010;
            #1;

            check_outputs(8'hD1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0011 (I=-3, Q=+3)", test_num);
            in_data = 4'b0011;
            #1;

            check_outputs(8'hD3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0100 (I=-1, Q=-3)", test_num);
            in_data = 4'b0100;
            #1;

            check_outputs(8'hFD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0101 (I=-1, Q=-1)", test_num);
            in_data = 4'b0101;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0110 (I=-1, Q=+1)", test_num);
            in_data = 4'b0110;
            #1;

            check_outputs(8'hF1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0111 (I=-1, Q=+3)", test_num);
            in_data = 4'b0111;
            #1;

            check_outputs(8'hF3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1000 (I=+1, Q=-3)", test_num);
            in_data = 4'b1000;
            #1;

            check_outputs(8'h1D);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1001 (I=+1, Q=-1)", test_num);
            in_data = 4'b1001;
            #1;

            check_outputs(8'h1F);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1010 (I=+1, Q=+1)", test_num);
            in_data = 4'b1010;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1011 (I=+1, Q=+3)", test_num);
            in_data = 4'b1011;
            #1;

            check_outputs(8'h13);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1100 (I=+3, Q=-3)", test_num);
            in_data = 4'b1100;
            #1;

            check_outputs(8'h3D);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1101 (I=+3, Q=-1)", test_num);
            in_data = 4'b1101;
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1110 (I=+3, Q=+1)", test_num);
            in_data = 4'b1110;
            #1;

            check_outputs(8'h31);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1111 (I=+3, Q=+3)", test_num);
            in_data = 4'b1111;
            #1;

            check_outputs(8'h33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_mapper Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [7:0] expected_qam_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_qam_out === (expected_qam_out ^ qam_out ^ expected_qam_out)) begin
                $display("PASS");
                $display("  Outputs: qam_out=%h",
                         qam_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qam_out=%h",
                         expected_qam_out);
                $display("  Got:      qam_out=%h",
                         qam_out);
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
