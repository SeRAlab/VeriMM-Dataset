`timescale 1ns/1ps

module muxer_tb;

    // Testbench signals (combinational circuit)
    reg const_effective;
    reg [197:0] from_const;
    reg [197:0] from_ram;
    wire [197:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    muxer dut (
        .const_effective(const_effective),
        .from_const(from_const),
        .from_ram(from_ram),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting from_ram (const_effective = 0)", test_num);
            from_ram   = 198'h1234567890ABCDEF1234567890ABCDEF1234567890ABCDE;
            from_const = 198'hFEDCBA0987654321FEDCBA0987654321FEDCBA098765432;
            const_effective = 1'b0;
            #1;

            check_outputs(from_ram);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting from_const (const_effective = 1)", test_num);
            from_ram   = 198'h1234567890ABCDEF1234567890ABCDEF1234567890ABCDE;
            from_const = 198'hFEDCBA0987654321FEDCBA0987654321FEDCBA098765432;
            const_effective = 1'b1;
            #1;

            check_outputs(from_const);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones in RAM, all zeros in Const - Select RAM", test_num);
            from_ram   = {198{1'b1}};
            from_const = {198{1'b0}};
            const_effective = 1'b0;
            #1;

            check_outputs(from_ram);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones in RAM, all zeros in Const - Select Const", test_num);
            from_ram   = {198{1'b1}};
            from_const = {198{1'b0}};
            const_effective = 1'b1;
            #1;

            check_outputs(from_const);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggling control signal with static data", test_num);
            from_ram   = 198'h33333333333333333333333333333333333333333333333333;
            from_const = 198'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;

            const_effective = 1'b1;
            #5;
            const_effective = 1'b0;
            #1;

            check_outputs(from_ram);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary bit check (MSB/LSB)", test_num);

            from_ram = (198'b1 << 197) | 198'b1;
            from_const = 198'h0;
            const_effective = 1'b0;
            #1;

            check_outputs(from_ram);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("muxer Testbench");
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
        input [197:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
