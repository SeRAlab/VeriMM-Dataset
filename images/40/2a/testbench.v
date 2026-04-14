`timescale 1ns/1ps

module ofdm_mapper_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [15:0] ofdm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_mapper dut (
        .data_in(data_in),
        .ofdm_out(ofdm_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase001: Data In = 4'h0");
        data_in = 4'h0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase002: Data In = 4'h1");
        data_in = 4'h1;
        #1;

        check_outputs(16'h1111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase003: Data In = 4'h2");
        data_in = 4'h2;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase004: Data In = 4'h3");
        data_in = 4'h3;
        #1;

        check_outputs(16'h3333);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase005: Data In = 4'h4");
        data_in = 4'h4;
        #1;

        check_outputs(16'h4444);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase006: Data In = 4'h5");
        data_in = 4'h5;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase007: Data In = 4'h6");
        data_in = 4'h6;
        #1;

        check_outputs(16'h6666);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running Testcase008: Data In = 4'h7");
        data_in = 4'h7;
        #1;

        check_outputs(16'h7777);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Running Testcase009: Data In = 4'h8");
        data_in = 4'h8;
        #1;

        check_outputs(16'h8888);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Running Testcase010: Data In = 4'h9");
        data_in = 4'h9;
        #1;

        check_outputs(16'h9999);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Running Testcase011: Data In = 4'hA");
        data_in = 4'hA;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Running Testcase012: Data In = 4'hB");
        data_in = 4'hB;
        #1;

        check_outputs(16'hBBBB);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Running Testcase013: Data In = 4'hC");
        data_in = 4'hC;
        #1;

        check_outputs(16'hCCCC);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Running Testcase014: Data In = 4'hD");
        data_in = 4'hD;
        #1;

        check_outputs(16'hDDDD);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Running Testcase015: Data In = 4'hE");
        data_in = 4'hE;
        #1;

        check_outputs(16'hEEEE);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Running Testcase016: Data In = 4'hF");
        data_in = 4'hF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_mapper Testbench");
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
        input [15:0] expected_ofdm_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ofdm_out === (expected_ofdm_out ^ ofdm_out ^ expected_ofdm_out)) begin
                $display("PASS");
                $display("  Outputs: ofdm_out=%h",
                         ofdm_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ofdm_out=%h",
                         expected_ofdm_out);
                $display("  Got:      ofdm_out=%h",
                         ofdm_out);
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
