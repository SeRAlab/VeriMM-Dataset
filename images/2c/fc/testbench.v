`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (combinational circuit)
    reg Ctrl;
    reg [4:0] D;
    wire [4:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .Ctrl(Ctrl),
        .D(D),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initialize and Set value to 5'h0A", test_num);

            Ctrl = 1;
            D = 5'h00;
            #10;

            D = 5'h0A;
            Ctrl = 1;
            #10;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disable Ctrl and change D (Hold value)", test_num);

            Ctrl = 1;
            D = 5'h15;
            #10;

            Ctrl = 0;
            #10;

            D = 5'h00;
            #10;

            #1;


            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write all ones", test_num);

            Ctrl = 1;
            D = 5'h00;
            #10;

            D = 5'b11111;
            Ctrl = 1;
            #10;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify memory retention during input toggle", test_num);

            Ctrl = 1;
            D = 5'h0F;
            #10;

            Ctrl = 0;
            #5;

            D = 5'h1A; #5;
            D = 5'h05; #5;
            D = 5'h1F; #5;

            #1;


            check_outputs(5'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential write transitions", test_num);

            Ctrl = 1;
            D = 5'h00;
            #10;

            D = 5'h11; #10;

            D = 5'h12; #10;

            D = 5'h13; #10;
            #1;

            check_outputs(5'h13);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
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
        input [4:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
