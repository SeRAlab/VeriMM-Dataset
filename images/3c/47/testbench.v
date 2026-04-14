`timescale 1ns/1ps

module packet_filtering_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest_ip;
    reg [4:0] src_ip;
    wire allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filtering dut (
        .dest_ip(dest_ip),
        .src_ip(src_ip),
        .allowed(allowed)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Lower boundary of src_ip (5) with correct dest_ip (15)", test_num);
        src_ip = 5'd5;
        dest_ip = 5'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Upper boundary of src_ip (10) with correct dest_ip (15)", test_num);
        src_ip = 5'd10;
        dest_ip = 5'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Middle of src_ip range (8) with correct dest_ip (15)", test_num);
        src_ip = 5'd8;
        dest_ip = 5'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Just below src_ip range (4) with correct dest_ip (15)", test_num);
        src_ip = 5'd4;
        dest_ip = 5'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Just above src_ip range (11) with correct dest_ip (15)", test_num);
        src_ip = 5'd11;
        dest_ip = 5'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum src_ip (0) with correct dest_ip (15)", test_num);
        src_ip = 5'd0;
        dest_ip = 5'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum src_ip (31) with correct dest_ip (15)", test_num);
        src_ip = 5'd31;
        dest_ip = 5'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid src_ip (7) but incorrect dest_ip (14)", test_num);
        src_ip = 5'd7;
        dest_ip = 5'd14;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid src_ip (7) but incorrect dest_ip (16)", test_num);
        src_ip = 5'd7;
        dest_ip = 5'd16;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid src_ip (7) but incorrect dest_ip (0)", test_num);
        src_ip = 5'd7;
        dest_ip = 5'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid src_ip (7) but incorrect dest_ip (31)", test_num);
        src_ip = 5'd7;
        dest_ip = 5'd31;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both src_ip and dest_ip out of range", test_num);
        src_ip = 5'd20;
        dest_ip = 5'd5;
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
        $display("packet_filtering Testbench");
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
        input expected_allowed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allowed === (expected_allowed ^ allowed ^ expected_allowed)) begin
                $display("PASS");
                $display("  Outputs: allowed=%b",
                         allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allowed=%b",
                         expected_allowed);
                $display("  Got:      allowed=%b",
                         allowed);
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
