`timescale 1ns/1ps

module qam_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] I;
    reg [1:0] Q;
    wire [3:0] QAM_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_encoder dut (
        .I(I),
        .Q(Q),
        .QAM_out(QAM_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input IQ = 2'b00", test_num);
            I = 2'b00;
            Q = 2'b00;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input IQ = 2'b01", test_num);
            I = 2'b00;
            Q = 2'b01;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input IQ = 2'b10", test_num);
            I = 2'b01;
            Q = 2'b00;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input IQ = 2'b11", test_num);
            I = 2'b01;
            Q = 2'b01;

            #1;


            check_outputs(4'b0011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_QAM_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_QAM_out === (expected_QAM_out ^ QAM_out ^ expected_QAM_out)) begin
                $display("PASS");
                $display("  Outputs: QAM_out=%h",
                         QAM_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: QAM_out=%h",
                         expected_QAM_out);
                $display("  Got:      QAM_out=%h",
                         QAM_out);
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
