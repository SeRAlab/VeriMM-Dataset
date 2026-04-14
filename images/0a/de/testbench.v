`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] allowed_addr;
    reg [4:0] src_addr;
    wire permit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .allowed_addr(allowed_addr),
        .src_addr(src_addr),
        .permit(permit)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Exact Match (src_addr == allowed_addr)", test_num);
        allowed_addr = 5'd10;
        src_addr     = 5'd10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mismatch (src_addr != allowed_addr)", test_num);
        allowed_addr = 5'd10;
        src_addr     = 5'd11;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Address Match", test_num);
        allowed_addr = 5'b00000;
        src_addr     = 5'b00000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Address Match", test_num);
        allowed_addr = 5'b11111;
        src_addr     = 5'b11111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Difference (LSB)", test_num);
        allowed_addr = 5'b10101;
        src_addr     = 5'b10100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Difference (MSB)", test_num);
        allowed_addr = 5'b01111;
        src_addr     = 5'b11111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Opposite Patterns", test_num);
        allowed_addr = 5'b10101;
        src_addr     = 5'b01010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Allowed Address Change then Match", test_num);
        allowed_addr = 5'd25;
        src_addr     = 5'd25;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
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
        input expected_permit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_permit === (expected_permit ^ permit ^ expected_permit)) begin
                $display("PASS");
                $display("  Outputs: permit=%b",
                         permit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: permit=%b",
                         expected_permit);
                $display("  Got:      permit=%b",
                         permit);
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
