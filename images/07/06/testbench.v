`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] allowed_ip;
    reg [31:0] packet_ip;
    wire allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .allowed_ip(allowed_ip),
        .packet_ip(packet_ip),
        .allowed(allowed)
    );
    task testcase001;

        begin
            test_num = 1;
            allowed_ip = 32'hC0A80001;
            packet_ip  = 32'hC0A80001;
            $display("Test %0d: Matching IP addresses (Exact match)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            allowed_ip = 32'hC0A80001;
            packet_ip  = 32'hC0A80002;
            $display("Test %0d: Different IP addresses (Mismatch)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            allowed_ip = 32'h00000000;
            packet_ip  = 32'h00000000;
            $display("Test %0d: Boundary condition - All zeros match", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            allowed_ip = 32'hFFFFFFFF;
            packet_ip  = 32'hFFFFFFFF;
            $display("Test %0d: Boundary condition - All ones match", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            allowed_ip = 32'hAAAAAAAA;
            packet_ip  = 32'h55555555;
            $display("Test %0d: Complementary bit patterns mismatch", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            allowed_ip = 32'h12345678;
            packet_ip  = 32'h12345679;
            $display("Test %0d: Single bit difference at LSB", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            allowed_ip = 32'h12345678;
            packet_ip  = 32'h92345678;
            $display("Test %0d: Single bit difference at MSB", test_num);
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
        $display("packet_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
