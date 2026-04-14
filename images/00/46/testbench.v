`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest_addr;
    reg enable;
    reg [4:0] src_addr;
    wire [9:0] mac_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .dest_addr(dest_addr),
        .enable(enable),
        .src_addr(src_addr),
        .mac_output(mac_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Concatenation (Enable High)", test_num);
            dest_addr = 5'h0A;
            src_addr  = 5'h05;
            enable    = 1'b1;
            #1;

            check_outputs(10'h145);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Address Values (Enable High)", test_num);
            dest_addr = 5'h1F;
            src_addr  = 5'h1F;
            enable    = 1'b1;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Low Verification", test_num);
            dest_addr = 5'h1F;
            src_addr  = 5'h1F;
            enable    = 1'b0;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Pattern (Enable High)", test_num);
            dest_addr = 5'h15;
            src_addr  = 5'h0A;
            enable    = 1'b1;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source Only Address (Enable High)", test_num);
            dest_addr = 5'h00;
            src_addr  = 5'h12;
            enable    = 1'b1;
            #1;

            check_outputs(10'h012);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Destination Only Address (Enable High)", test_num);
            dest_addr = 5'h12;
            src_addr  = 5'h00;
            enable    = 1'b1;
            #1;

            check_outputs(10'h240);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Addresses (Enable High)", test_num);
            dest_addr = 5'h00;
            src_addr  = 5'h00;
            enable    = 1'b1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [9:0] expected_mac_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mac_output === (expected_mac_output ^ mac_output ^ expected_mac_output)) begin
                $display("PASS");
                $display("  Outputs: mac_output=%h",
                         mac_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mac_output=%h",
                         expected_mac_output);
                $display("  Got:      mac_output=%h",
                         mac_output);
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
