`timescale 1ns/1ps

module mux32to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg [4:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux32to1 dut (
        .data_in(data_in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Select 0, bit 0 is High", test_num);
        data_in = 32'h0000_0001;
        sel = 5'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Select 0, bit 0 is Low", test_num);
        data_in = 32'hFFFE_FFFE;
        data_in[0] = 1'b0;
        sel = 5'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Select 31, bit 31 is High", test_num);
        data_in = 32'h8000_0000;
        sel = 5'd31;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Select 31, bit 31 is Low", test_num);
        data_in = 32'h7FFF_FFFF;
        sel = 5'd31;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Select 15, bit 15 is High", test_num);
        data_in = 32'h0000_8000;
        sel = 5'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Select 10, bit 10 is Low, others High", test_num);
        data_in = ~(32'h0000_0400);
        sel = 5'd10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Alternating pattern, Select 1 (High)", test_num);
        data_in = 32'hAAAA_AAAA;
        sel = 5'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Alternating pattern, Select 2 (Low)", test_num);
        data_in = 32'hAAAA_AAAA;
        sel = 5'd2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux32to1 Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
