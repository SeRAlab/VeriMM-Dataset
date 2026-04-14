`timescale 1ns/1ps

module LDO_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Vin;
    reg [4:0] Vref;
    reg enable;
    wire [4:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO dut (
        .Vin(Vin),
        .Vref(Vref),
        .enable(enable),
        .Vout(Vout)
    );
    task testcase001;

        begin
            test_num = 1;
            enable = 0;
            Vin = 5'd20;
            Vref = 5'd10;
            $display("Testcase %0d: enable=0, Vin=20, Vref=10", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            enable = 1;
            Vin = 5'd25;
            Vref = 5'd15;
            $display("Testcase %0d: enable=1, Vin=25, Vref=15", test_num);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            enable = 1;
            Vin = 5'd12;
            Vref = 5'd12;
            $display("Testcase %0d: enable=1, Vin=12, Vref=12", test_num);
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            enable = 1;
            Vin = 5'd8;
            Vref = 5'd12;
            $display("Testcase %0d: enable=1, Vin=8, Vref=12", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            enable = 0;
            Vin = 5'd5;
            Vref = 5'd10;
            $display("Testcase %0d: enable=0, Vin=5, Vref=10", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            enable = 1;
            Vin = 5'd31;
            Vref = 5'd31;
            $display("Testcase %0d: enable=1, Vin=31, Vref=31", test_num);
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            enable = 1;
            Vin = 5'd0;
            Vref = 5'd1;
            $display("Testcase %0d: enable=1, Vin=0, Vref=1", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            enable = 1;
            Vin = 5'd10;
            Vref = 5'd0;
            $display("Testcase %0d: enable=1, Vin=10, Vref=0", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO Testbench");
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
        input [4:0] expected_Vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: Vout=%h",
                         Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%h",
                         expected_Vout);
                $display("  Got:      Vout=%h",
                         Vout);
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
