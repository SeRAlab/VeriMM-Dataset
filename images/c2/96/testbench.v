`timescale 1ns/1ps

module sum16_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg en;
    wire [15:0] data_out;
    wire ovf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sum16 dut (
        .data_in(data_in),
        .en(en),
        .data_out(data_out),
        .ovf(ovf)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic addition, no overflow (en=1)", test_num);
        en = 1'b1;
        data_in = 32'h0005_000A;
        #1;

        check_outputs(16'h000F, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic addition, with overflow (en=1)", test_num);
        en = 1'b1;
        data_in = 32'h8000_8000;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum values, with overflow (en=1)", test_num);
        en = 1'b1;
        data_in = 32'hFFFF_FFFF;
        #1;

        check_outputs(16'hFFFE, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary overflow (en=1)", test_num);
        en = 1'b1;
        data_in = 32'hFFFF_0001;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Module disabled with non-zero inputs (en=0)", test_num);
        en = 1'b0;
        data_in = 32'h0005_000A;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Module disabled with overflow inputs (en=0)", test_num);
        en = 1'b0;
        data_in = 32'hFFFF_FFFF;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with zeros (en=1)", test_num);
        en = 1'b1;
        data_in = 32'h0000_0000;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Re-enabling module after disable", test_num);
        en = 1'b0;
        data_in = 32'h1234_5678;
        #5;
        en = 1'b1;
        #1;

        check_outputs(16'h68AC, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hex boundary addition (en=1)", test_num);
        en = 1'b1;
        data_in = 32'hABCD_1234;
        #1;

        check_outputs(16'hBE01, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: One input zero addition (en=1)", test_num);
        en = 1'b1;
        data_in = 32'h0000_A5A5;
        #1;

        check_outputs(16'hA5A5, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sum16 Testbench");
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
        input [15:0] expected_data_out;
        input expected_ovf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ovf === (expected_ovf ^ ovf ^ expected_ovf)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ovf=%b",
                         data_out, ovf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ovf=%b",
                         expected_data_out, expected_ovf);
                $display("  Got:      data_out=%h, ovf=%b",
                         data_out, ovf);
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
