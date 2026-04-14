`timescale 1ns/1ps

module crc32_generator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    wire [31:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc32_generator dut (
        .data(data),
        .crc(crc)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero input", test_num);
        data = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Least Significant Bit set", test_num);
        data = 32'h00000001;

        #1;


        check_outputs(32'h04C11DB7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Second bit set", test_num);
        data = 32'h00000002;
        #1;

        check_outputs(32'h09823B6E);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Most Significant Bit set", test_num);
        data = 32'h80000000;
        #1;

        check_outputs(32'h33AA8845);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: All ones", test_num);
        data = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hCBF53A06);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Incremental pattern", test_num);
        data = 32'h12345678;
        #1;

        check_outputs(32'hC70B3551);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Alternating bits (A5)", test_num);
        data = 32'hA5A5A5A5;
        #1;

        check_outputs(32'h3D328C69);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Alternating bits (5A)", test_num);
        data = 32'h5A5A5A5A;
        #1;

        check_outputs(32'hF6C7B66F);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Common hex pattern", test_num);
        data = 32'hDEADBEEF;
        #1;

        check_outputs(32'h089989B1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Sparse bit pattern", test_num);
        data = 32'h00C0FFEE;
        #1;

        check_outputs(32'hA663A48C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc32_generator Testbench");
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
        input [31:0] expected_crc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc === (expected_crc ^ crc ^ expected_crc)) begin
                $display("PASS");
                $display("  Outputs: crc=%h",
                         crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc=%h",
                         expected_crc);
                $display("  Got:      crc=%h",
                         crc);
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
